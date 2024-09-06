import Epoxy
import UIKit

/// Source code for `EpoxyCollectionView` "Counter" example from `README.md`:
class MealListViewController: CollectionViewController {
  var api = ApiClient.liveValue

  // MARK: Lifecycle
  
  init() {
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = "Recipes"
    self.onAppear()
    setItems(items, animated: false)
  }
  
  // MARK: Private
  
  private enum DataID: Hashable  {
    case row(ApiClient.Meal.ID)
  }
  
  private struct State {
    let mealCategory = ApiClient.MealCategory.dessert
    var meals = [ApiClient.Meal]()
  }
  

  private var state = State() {
    didSet { setItems(items, animated: true) }
  }
  
  private func onAppear() {
    Task {
      do {
        let response = try await self.api.fetchAllMeals(self.state.mealCategory)
        await MainActor.run {
          self.state.meals = response
          print("did update self.meals")
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    self.state.meals.map { meal in
      TextRow.itemModel(
        dataID: DataID.row(meal.id),
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
