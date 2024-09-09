import Epoxy
import UIKit
import SwiftUI
import Combine

class MealCategoryListViewController: CollectionViewController {
  
  init(
    state: State,
    didSelectMealCategory: @escaping (ApiClient.MealCategory) -> Void = { _ in }
  ) {
    self.state = state
    self.didSelectMealCategory = didSelectMealCategory
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = "Categories"
    self.onAppear()
    setItems(items, animated: false)
  }
  
  var state: State {
    didSet { setItems(items, animated: true) }
  }
  var didSelectMealCategory: (ApiClient.MealCategory) -> Void
  
  private enum DataID: Hashable  {
    case row(ApiClient.MealCategory.ID)
  }
  
  struct State {
    var mealCategories = [ApiClient.MealCategory]()
    var cancellables = Set<AnyCancellable>()
  }
  
  private struct Environment {
    var api = ApiClient.liveValue
    var mainQueue = DispatchQueue.main
  }
  
  private let environment = Environment()
  
  private func onAppear() {
    self.environment.api.fetchAllMealCategories()
      .receive(on: self.environment.mainQueue)
      .sink { error in
        print(error)
      } receiveValue: { [weak self] value in
        print(value)
        self?.state.mealCategories = value
      }
      .store(in: &state.cancellables)
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    self.state.mealCategories.map { value in
      TextRow.itemModel(
        dataID: DataID.row(value.id),
        content: .init(title: "\(value.strCategory)"),
        style: .small
      )
      .didSelect { [weak self] _ in
        self?.didSelectMealCategory(value)
      }
    }
  }
}

// MARK: - Previews

struct MealCategoryListViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIKitPreview {
      MealCategoryListViewController(state: .init())
    }
  }
}
