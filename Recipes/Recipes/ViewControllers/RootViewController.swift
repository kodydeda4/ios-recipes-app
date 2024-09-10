import Epoxy
import UIKit
import SwiftUI
import Combine

// @DEDA - 12:00 SHows you can use @UIBindable var model with Perception tracking package.
// https://www.pointfree.co/episodes/ep290-cross-platform-swift-view-paradigms

final class RootViewController: NavigationController {
  private init() {
    super.init(wrapNavigation: NavigationWrapperViewController.init(navigationController:))
    setStack(stack, animated: false)
  }
  
  static var shared = RootViewController()
  
  private enum DataID: Hashable {
    case index
    case mealCategory(ApiClient.MealCategory.ID)
    case meal(ApiClient.Meal.ID)
  }
  
  private struct State {
    var destinationMealDetails: ApiClient.MealDetails?
    var destinationMealCategory: ApiClient.MealCategory?
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
    NavigationModel.root(dataID: DataID.index) {
      MealCategoryCollectionViewController(state: .init())
    }
    
    if let value = state.destinationMealCategory {
      NavigationModel(
        dataID: DataID.mealCategory(value.id),
        makeViewController: {
          MealCollectionViewController(
            state: .init(mealCategory: value)
          )
        },
        remove: { [weak self] in
          self?.state.destinationMealDetails = .none
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
        
  func navigate(mealDetails id: ApiClient.MealDetails.ID) {
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
  
  func navigate(mealCategory value: ApiClient.MealCategory) {
    self.state.destinationMealCategory = value
  }
}

// MARK: - Previews

struct RootViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIKitPreview {
      RootViewController.shared
    }
  }
}
