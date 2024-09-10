import Epoxy
import SwiftUI

final class MealDetailsViewController: CollectionViewController {
  
  struct State {
    let mealDetails: ApiClient.MealDetails
  }
  
  private var state: State {
    didSet {
      setItems(items, animated: false)
    }
  }

  init(state: State) {
    self.state = state
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = state.mealDetails.strMeal
    setItems(items, animated: false)
  }
}

// MARK: - View

extension MealDetailsViewController {
  private enum DataID {
    case headerImage
    case ingredientsTitle
    case ingredientsSubtitle
    case instructionsTitle
    case instructionsSubtitle
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

