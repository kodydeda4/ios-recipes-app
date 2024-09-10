import UIKit
import SwiftUI
import Combine
import Epoxy

final class AppViewController: NavigationController {
  static var shared = AppViewController()
  static var previewValue = AppViewController()

  private init() {
    super.init(wrapNavigation: NavigationWrapperViewController.init(navigationController:))
    setStack(stack, animated: false)
  }
  
  struct State {
    var path = [Path]()
    var cancellables = Set<AnyCancellable>()
    
    enum Path {
      case mealDetails(MealDetailsViewController.State)
      case mealCategory(MealCollectionViewController.State)
    }
  }
  
  private var state = State() {
    didSet { setStack(stack, animated: true) }
  }
  
  public func push(_ value: State.Path) {
    self.state.path.append(value)
  }
  
  public func pop() {
    self.state.path.removeLast()
  }
}

// MARK: - View

extension AppViewController {
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
        
      case let .mealCategory(state):
        NavigationModel(
          dataID: DataID.mealCategory(state.mealCategory.id),
          makeViewController: { MealCollectionViewController(state: state) },
          remove: { [weak self] in self?.pop() }
        )
        
      case let .mealDetails(state):
        NavigationModel(
          dataID: DataID.mealDetails(state.mealDetails.id),
          makeViewController: { MealDetailsViewController(state: state) },
          remove: { [weak self] in self?.pop() }
        )
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct AppViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerRepresenting {
      AppViewController.previewValue
    }
  }
}

