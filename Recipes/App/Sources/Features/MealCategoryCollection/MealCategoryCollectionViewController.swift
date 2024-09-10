import Epoxy
import UIKit
import SwiftUI
import Combine

class MealCategoryCollectionViewController: CollectionViewController {
  struct State {
    var mealCategories = [ApiClient.MealCategory]()
    var cancellables = Set<AnyCancellable>()
  }
  
  private struct Environment {
    var api = ApiClient.liveValue
    var mainQueue = DispatchQueue.main
  }
  
  var state: State {
    didSet { setItems(items, animated: true) }
  }
  
  private let environment = Environment()
  
  init(state: State) {
    self.state = state
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = "Meal Categories"
    self.setItems(items, animated: false)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
}
  
// MARK: - View

extension MealCategoryCollectionViewController {
  private enum DataID: Hashable  {
    case row(ApiClient.MealCategory.ID)
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    self.state.mealCategories.map { (mealCategory: ApiClient.MealCategory) in
      CardContainer<BarStackView>.itemModel(
        dataID: DataID.row(mealCategory.id),
        content: .init(
          models: [
            TextRow.barModel(
              content: .init(title: "\(mealCategory.strCategory)"),
              style: .small
            ),
            ImageMarquee.barModel(
              content: .init(imageURL: mealCategory.strCategoryThumb),
              style: .init(height: 150, contentMode: .scaleAspectFill)
            )
          ],
          selectedBackgroundColor: .secondarySystemBackground),
        style: .init(card: .init())
      )
      .didSelect { _ in
        AppViewController.shared.push(.mealCategory(
          .init(mealCategory: mealCategory))
        )
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct MealCategoryListViewController_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UIViewControllerRepresenting {
        MealCategoryCollectionViewController(state: .init())
      }
      .navigationTitle("Category")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}
