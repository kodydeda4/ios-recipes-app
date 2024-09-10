import EpoxyCore
import UIKit

public final class Label: UILabel, EpoxyableView {
  
  // MARK: Lifecycle
  
  public init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    font = style.font
    numberOfLines = style.numberOfLines
    if style.showLabelBackground {
      backgroundColor = .secondarySystemBackground
    }
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Internal
  
  // MARK: StyledView
  
  public struct Style: Hashable {
    let font: UIFont
    let showLabelBackground: Bool
    var numberOfLines = 0
  }
  
  // MARK: ContentConfigurableView
  
  public typealias Content = String
  
  public func setContent(_ content: String, animated _: Bool) {
    text = content
  }
}

public extension Label.Style {
  static func style(
    with textStyle: UIFont.TextStyle,
    showBackground: Bool = false
  )
    -> Label.Style
  {
    .init(
      font: UIFont.preferredFont(forTextStyle: textStyle),
      showLabelBackground: showBackground
    )
  }
}
