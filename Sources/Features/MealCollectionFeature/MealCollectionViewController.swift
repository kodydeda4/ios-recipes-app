import ApiClient
import Combine
import Environment
import Epoxy
import SharedViews
import SwiftUI
import UIKit
import UIKitHelpers

public final class MealCollectionViewController: CollectionViewController {

  public struct State {
    let mealCategory: ApiClient.MealCategory
    var meals = [ApiClient.Meal]()
    var cancellables = Set<AnyCancellable>()
  }

  private var state: State { didSet { setItems(items, animated: true) } }
  private var environment = Environment.shared

  public init(state: State) {
    self.state = state
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = "\(state.mealCategory.strCategory) Meals"
    setItems(items, animated: false)
  }

  public override func viewDidLoad() {
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
      } receiveValue: { [weak self] value in
        print(value)
        //@DEDA
//        if let mealDetails = value.last {
//          self?.environment.navigationStack.push(.mealDetails(
//            .init(mealDetails: mealDetails))
//          )
//        }
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
    []
//    self.state.meals.map { meal in
    //@DEDA
//      TextRow.itemModel(
//        dataID: DataID.row(meal.id),
//        content: .init(title: "\(meal.strMeal)"),
//        style: .small
//      )
//      .didSelect { [weak self] _ in
//        self?.didSelect(meal)
//      }
//    }
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
