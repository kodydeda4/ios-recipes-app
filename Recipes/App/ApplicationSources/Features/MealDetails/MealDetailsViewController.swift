import Epoxy
import SwiftUI

final class MealDetailsViewController: CollectionViewController {
  
  init(state: State) {
    self.state = state
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = state.mealDetails.strMeal
    setItems(items, animated: false)
  }
  
  struct State {
    let mealDetails: ApiClient.MealDetails
  }
  
  private enum DataID {
    case headerImage
    case ingredientsTitle
    case ingredientsSubtitle
    case instructionsTitle
    case instructionsSubtitle
  }
  
  private var state: State {
    didSet {
      setItems(items, animated: false)
    }
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    ImageMarquee.itemModel(
      dataID: DataID.headerImage,
      content: .init(imageURL: URL(string: "\(state.mealDetails.strMealThumb)")!),
      style: .init(height: 250, contentMode: .scaleAspectFill)
    )
    TextRow.itemModel(
      dataID: DataID.instructionsTitle,
      content: .init(title: "🛒 Ingredients"),
      style: .large
    )
    TextRow.itemModel(
      dataID: DataID.ingredientsSubtitle,
      content: .init(title: "\(state.mealDetails.strInstructions)"),
      style: .small
    )
    TextRow.itemModel(
      dataID: DataID.instructionsTitle,
      content: .init(title: "📖 Instructions"),
      style: .large
    )
    state.mealDetails.ingredientMeasures.compactMap { value in
      TextRow.itemModel(
        dataID: DataID.instructionsSubtitle,
        content: .init(title: value.strMeasure + " " + value.strIngredient),
        style: .small
      )
    }
  }
}

// MARK: - ImageMarquee

private final class ImageMarquee: UIView, EpoxyableView {
  
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

// MARK: - Previews

struct MealDetailsViewController_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UIViewControllerRepresenting {
        MealDetailsViewController(state: .init(mealDetails: .previewValue))
      }
    }
  }
}

