import UIKit
import Epoxy
import SwiftUI

final class MealDetailsViewController: CollectionViewController {
  let mealDetails: ApiClient.MealDetails
  
  init(mealDetails: ApiClient.MealDetails) {
    self.mealDetails = mealDetails
    super.init(layout: UICollectionViewCompositionalLayout.list)
    setItems(items, animated: false)
  }
  
  private enum DataID {
    enum Item {
      case headerImage, titleRow, instructionsRow
    }
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    ImageMarquee.itemModel(
      dataID: DataID.Item.headerImage,
      content: .init(imageURL: URL(string: "\(mealDetails.strMealThumb)")!),
      style: .init(height: 250, contentMode: .scaleAspectFill)
    )
    TextRow.itemModel(
      dataID: DataID.Item.titleRow,
      content: .init(title: "\(mealDetails.strMeal)"),
      style: .large
    )
    TextRow.itemModel(
      dataID: DataID.Item.instructionsRow,
      content: .init(title: "\(mealDetails.strInstructions)"),
      style: .small
    )
  }
}

// MARK: - ImageMarquee

private final class ImageMarquee: UIView, EpoxyableView {

  // MARK: Lifecycle

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

  // MARK: Internal

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

  // MARK: Private

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

// MARK: - Previews

struct MealDetailsViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIKitPreview {
      MealDetailsViewController(mealDetails: .previewValue)
    }
  }
}
