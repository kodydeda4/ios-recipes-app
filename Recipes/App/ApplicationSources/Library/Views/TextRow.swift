import Epoxy
import UIKit

final class TextRow: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    group.install(in: self)
    group.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
    let title: UIFont.TextStyle
    let body: UIFont.TextStyle
    
    static var small = Self(title: .headline, body: .body)
    static var large = Self(title: .body, body: .caption1)
  }

  struct Content: Equatable {
    var title: String?
    var body: String?
  }

  func setContent(_ content: Content, animated _: Bool) {

    group.setItems {
      if let title = content.title {
        Label.groupItem(
          dataID: DataID.title,
          content: title,
          style: .style(with: style.title))
          .adjustsFontForContentSizeCategory(true)
          .textColor(UIColor.label)
      }
      if let body = content.body {
        Label.groupItem(
          dataID: DataID.body,
          content: body,
          style: .style(with: style.body))
          .adjustsFontForContentSizeCategory(true)
          .numberOfLines(0)
          .textColor(UIColor.secondaryLabel)
      }
    }
  }

  // MARK: Private

  private enum DataID {
    case title
    case body
  }

  private let style: Style
  private let group = VGroup(spacing: 8)
}

// MARK: SelectableView

extension TextRow: SelectableView {
  func didSelect() {
    // Handle this row being selected, e.g. to trigger haptics:
    UISelectionFeedbackGenerator().selectionChanged()
  }
}

// MARK: HighlightableView

extension TextRow: HighlightableView {
  func didHighlight(_ isHighlighted: Bool) {
    UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
      self.transform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
    }
  }
}

// MARK: DisplayRespondingView

extension TextRow: DisplayRespondingView {
  func didDisplay(_: Bool) {
    // Handle this row being displayed.
  }
}
