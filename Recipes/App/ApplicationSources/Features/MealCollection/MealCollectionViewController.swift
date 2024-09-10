import Epoxy
import UIKit
import SwiftUI
import Combine

class MealCollectionViewController: CollectionViewController {
  
  struct State {
    let mealCategory: ApiClient.MealCategory
    var meals = [ApiClient.Meal]()
    var cancellables = Set<AnyCancellable>()
  }
  
  private struct Environment {
    var api = ApiClient.liveValue
    var mainQueue = DispatchQueue.main
  }
  
  private var state: State {
    didSet { setItems(items, animated: true) }
  }
  
  private let environment = Environment()
  
  init(state: State) {
    self.state = state
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = "\(state.mealCategory.strCategory) Meals"
    setItems(items, animated: false)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
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
  
  private func didSelect(_ meal: ApiClient.Meal) {
    self.environment.api.fetchMealDetailsById(meal.id)
      .receive(on: self.environment.mainQueue)
      .sink { error in
        print(error)
      } receiveValue: { value in
        print(value)
        if let mealDetails = value.last {
          AppViewController.shared.push(.mealDetails(
            .init(mealDetails: mealDetails))
          )
        }
      }
      .store(in: &self.state.cancellables)
  }
}

// MARK: - View

extension MealCollectionViewController {
  private enum DataID: Hashable  {
    case row(ApiClient.Meal.ID)
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    self.state.meals.map { meal in
      TextRow.itemModel(
        dataID: DataID.row(meal.id),
        content: .init(title: "\(meal.strMeal)"),
        style: .small
      )
      .didSelect { [weak self] _ in
        self?.didSelect(meal)
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct MealListViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerRepresenting {
      MealCollectionViewController(
        state: .init(
          mealCategory: .previewValue
        )
      )
    }
  }
}
