import Epoxy
import UIKit
import SwiftUI
import Combine

final class AppViewController: NavigationController {
  
  // MARK: Lifecycle
  
  init() {
    super.init(wrapNavigation: NavigationWrapperViewController.init(navigationController:))
    setStack(stack, animated: false)
  }
  
  // MARK: Private
  
  private enum DataID: Hashable {
    case index
    case meal(ApiClient.Meal.ID)
  }
  
  private struct State {
    var destinationMealDetails: ApiClient.MealDetails?
    var cancellables = Set<AnyCancellable>()
  }
  
  private struct Environment {
    var api = ApiClient.liveValue
    var mainQueue = DispatchQueue.main
  }
  
  private var state = State() {
    didSet { setStack(stack, animated: true) }
  }
  
  private let environment = Environment()
  
  @NavigationModelBuilder private var stack: [NavigationModel] {
    NavigationModel.root(dataID: DataID.index) { [weak self] in
      MealListViewController(
        didSelectMealID: { id in
          self?.navigateToMealDetails(id: id)
        }
      )
    }
    
    if let value = state.destinationMealDetails {
      NavigationModel(
        dataID: DataID.meal(value.id),
        makeViewController: {
          MealDetailsViewController(mealDetails: value)
        },
        remove: { [weak self] in
          self?.state.destinationMealDetails = .none
        }
      )
    }
  }
  
  private func navigateToMealDetails(id: ApiClient.MealDetails.ID) {
    self.environment.api.fetchMealDetailsById(id)
      .receive(on: self.environment.mainQueue)
      .sink { error in
        print(error)
      } receiveValue: { [weak self] value in
        print(value)
        self?.state.destinationMealDetails = value.last
      }
      .store(in: &self.state.cancellables)
  }
}

// MARK: - Previews

struct AppViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIKitPreview {
      AppViewController()
    }
  }
}
