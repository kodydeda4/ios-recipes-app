import Epoxy
import UIKit
import SwiftUI
import Combine

class MealListViewController: CollectionViewController {
  
  // MARK: Lifecycle
  
  init(
    didSelectMealID: @escaping (ApiClient.Meal.ID) -> Void = { _ in }
  ) {
    self.didSelectMealID = didSelectMealID
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = "Recipes"
    self.onAppear()
    setItems(items, animated: false)
  }
  
  var didSelectMealID: (ApiClient.Meal.ID) -> Void
  
  // MARK: Private
  
  private enum DataID: Hashable  {
    case row(ApiClient.Meal.ID)
  }
  
  private struct State {
    let mealCategory = ApiClient.MealCategory.dessert
    var meals = [ApiClient.Meal]()
    var cancellables = Set<AnyCancellable>()
  }
  
  private struct Environment {
    var api = ApiClient.liveValue
    var mainQueue = DispatchQueue.main
  }
  
  private var state = State() {
    didSet { setItems(items, animated: true) }
  }
  
  private let environment = Environment()
  
  private func onAppear() {
    self.environment.api.fetchAllMeals(self.state.mealCategory)
      .receive(on: self.environment.mainQueue)
      .sink { error in
        print(error)
      } receiveValue: { [weak self] value in
        print(value)
        self?.state.meals = value
      }
      .store(in: &state.cancellables)
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    self.state.meals.map { meal in
      TextRow.itemModel(
        dataID: DataID.row(meal.id),
        content: .init(
          title: "\(meal.strMeal)",
          body: "Description"),
        style: .large
      )
      .didSelect { [weak self] _ in
        self?.didSelectMealID(meal.id)
      }
    }
  }
}

// MARK: - Previews

struct MealListViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIKitPreview {
      MealListViewController()
    }
  }
}
