import ApiClient
import Combine
import Environment
import Epoxy
import MealCategoryCollectionFeature
import MealCollectionFeature
import MealDetailsFeature
import NavigationControllerClient
import SharedViews
import SwiftUI
import UIKit
import UIKitHelpers

public final class AppViewController: NavigationController {
  public static var shared = AppViewController()
  static var previewValue = AppViewController()

  struct State {
    var path = [NavigationControllerClient.Path]()
  }

  private var state: State { didSet { setStack(stack, animated: true) } }
  private var environment = Environment.shared

  private init() {
    self.state = State()
    super.init(wrapNavigation: NavigationWrapperViewController.init)
    self.environment.navigationStack.push = { self.state.path.append($0) }
    self.environment.navigationStack.pop = { self.state.path.removeLast() }
    setStack(stack, animated: false)
  }
}

// MARK: - View

private extension AppViewController {
  private enum DataID: Hashable {
    case index
    case mealCategory(ApiClient.MealCategory.ID)
    case mealDetails(ApiClient.Meal.ID)
  }

  @NavigationModelBuilder private var stack: [NavigationModel] {
    NavigationModel.root(dataID: DataID.index) {
      MealCategoryCollectionViewController(state: .init())
    }

    for path in state.path {
      switch path {

      case let .mealCategory(value):
        NavigationModel(
          dataID: DataID.mealCategory(value.id),
          makeViewController: {
            MealCollectionViewController(state: .init(mealCategory: value))
          },
          remove: { [weak self] in
            self?.environment.navigationStack.pop()
          }
        )

      case let .mealDetails(value):
        NavigationModel(
          dataID: DataID.mealDetails(value.id),
          makeViewController: {
            MealDetailsViewController(state: .init(mealDetails: value))
          },
          remove: { [weak self] in
            self?.environment.navigationStack.pop()
          }
        )
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct AppViewControler_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerRepresenting {
      AppViewController.previewValue
    }
  }
}

