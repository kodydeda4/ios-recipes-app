import Epoxy
import UIKit
import SwiftUI
import Combine

final class RootViewController: NavigationController {
  static var shared = RootViewController()
  
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
        
      case let .mealCategory(path):
        NavigationModel(
          dataID: DataID.mealCategory(path.mealCategory.id),
          makeViewController: { MealCollectionViewController(state: path) },
          remove: { [weak self] in self?.pop() }
        )
        
      case let .mealDetails(path):
        NavigationModel(
          dataID: DataID.mealDetails(path.mealDetails.id),
          makeViewController: { MealDetailsViewController(state: path) },
          remove: { [weak self] in self?.pop() }
        )
      }
    }
  }
}

// MARK: - Global Navigation

extension RootViewController {
  func push(_ value: State.Path) {
    self.state.path.append(value)
  }
  
  func pop() {
    self.state.path.removeLast()
  }
}

// MARK: - Previews

struct RootViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerRepresenting {
      RootViewController.shared
    }
  }
}
