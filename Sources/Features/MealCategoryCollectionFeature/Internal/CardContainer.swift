import Epoxy
import UIKit

/// A container that draws a card around a content view.
final class CardContainer<ContentView: EpoxyableView>: UIView, EpoxyableView {
  
  // MARK: Lifecycle
  
  init(style: Style) {
    self.style = style.card
    if ContentView.Style.self == Never.self {
      contentView = ContentView()
    } else {
      contentView = ContentView(style: style.content)
    }
    super.init(frame: .zero)
    addSubviews()
    setUpConstraints()
    applyStyle()
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Internal
  
  struct Style: Hashable {
    init(content: ContentView.Style, card: CardStyle) {
      self.content = content
      self.card = card
    }
    
    init(card: CardStyle) where ContentView.Style == Never {
      self.card = card
    }
    
    fileprivate var content: ContentView.Style!
    fileprivate var card: CardStyle
  }
  
  struct CardStyle: Hashable {
    var cornerRadius: CGFloat = 10
    var layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    var cardBackgroundColor = UIColor.secondarySystemBackground
    var borderColor = UIColor.tertiarySystemBackground
    var borderWidth: CGFloat = 1
  }
  
  let contentView: ContentView
  
  func setContent(_ content: ContentView.Content, animated: Bool) {
    contentView.setContent(content, animated: animated)
  }
  
  // MARK: Private
  
  private let style: CardStyle
  
  private lazy var contentContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = true
    view.layer.cornerRadius = style.cornerRadius
    view.backgroundColor = style.cardBackgroundColor
    view.layer.borderWidth = style.borderWidth
    view.layer.borderColor = style.borderColor.cgColor
    return view
  }()
  
  private func addSubviews() {
    contentContainer.addSubview(contentView)
    addSubview(contentContainer)
  }
  
  private func setUpConstraints() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
      contentView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
      contentView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
      contentContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      contentContainer.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      contentContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      contentContainer.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
    ])
  }
  
  private func applyStyle() {
    layoutMargins = style.layoutMargins
  }
  
}

// MARK: - UIEdgeInsets + Hashable

extension UIEdgeInsets: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(left)
    hasher.combine(right)
    hasher.combine(top)
    hasher.combine(bottom)
  }
}

// MARK: - CGSize + Hashable

extension CGSize: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(height)
    hasher.combine(width)
  }
}

