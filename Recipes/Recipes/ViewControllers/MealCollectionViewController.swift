import Epoxy
import UIKit
import SwiftUI
import Combine

class MealCollectionViewController: CollectionViewController {
  init(
    state: State,
    didSelectMealID: @escaping (ApiClient.Meal.ID) -> Void = { _ in }
  ) {
    self.state = state
    self.didSelectMealID = didSelectMealID
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = state.mealCategory.strCategory
    self.onAppear()
    setItems(items, animated: false)
  }
  
  var state: State {
    didSet { setItems(items, animated: true) }
  }
  var didSelectMealID: (ApiClient.Meal.ID) -> Void
  
  private enum DataID: Hashable  {
    case row(ApiClient.Meal.ID)
  }
  
  struct State {
    let mealCategory: ApiClient.MealCategory
    var meals = [ApiClient.Meal]()
    var cancellables = Set<AnyCancellable>()
  }
  
  private struct Environment {
    var api = ApiClient.liveValue
    var mainQueue = DispatchQueue.main
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
        content: .init(title: "\(meal.strMeal)"),
        style: .small
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
      MealCollectionViewController(
        state: .init(
          mealCategory: .previewValue
        )
      )
    }
  }
}
