import Epoxy
import UIKit

/// Source code for `EpoxyCollectionView` "Counter" example from `README.md`:
class MealListViewController: CollectionViewController {
  
  // MARK: Lifecycle
  
  init() {
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.onAppear()
    setItems(items, animated: false)
  }
  
  // MARK: Private
  
  private enum DataID {
    case row
  }
  
  private var api = ApiClient.liveValue
  private let mealCategory = ApiClient.MealCategory.dessert
  
  private var meals = [ApiClient.Meal]() {
    didSet { setItems(items, animated: true) }
  }
  
  private func onAppear() {
    Task {
      do {
        let response = try await self.api.fetchAllMeals(self.mealCategory)
        await MainActor.run {
          self.meals = response
          print("did update self.meals")
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    self.meals.map { meal in
      TextRow.itemModel(
        dataID: DataID.row,
        content: .init(
          title: "\(meal.strMeal)",
          body: "Description"),
        style: .large)
      .didSelect { [weak self] _ in
        //...
      }
    }
  }
}
