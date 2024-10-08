import Epoxy
import UIKit

extension MealDetailsViewController {
  final class ImageMarquee: UIView, EpoxyableView {
    
    init(style: Style) {
      self.style = style
      super.init(frame: .zero)
      contentMode = style.contentMode
      clipsToBounds = true
      addSubviews()
      constrainSubviews()
    }
    
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    struct Style: Hashable {
      var height: CGFloat
      var contentMode: UIView.ContentMode
    }
    
    struct Content: Equatable {
      var imageURL: URL?
    }
    
    func setContent(_ content: Content, animated _: Bool) {
      imageView.setURL(content.imageURL)
    }
    
    private let style: Style
    private let imageView = UIImageView()
    
    private func addSubviews() {
      addSubview(imageView)
    }
    
    private func constrainSubviews() {
      imageView.translatesAutoresizingMaskIntoConstraints = false
      let heightAnchor = imageView.heightAnchor.constraint(equalToConstant: style.height)
      heightAnchor.priority = .defaultHigh
      NSLayoutConstraint.activate([
        heightAnchor,
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        imageView.topAnchor.constraint(equalTo: topAnchor),
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      ])
    }
    
  }
}
