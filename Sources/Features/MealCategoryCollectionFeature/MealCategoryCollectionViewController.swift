import ApiClient
import Combine
import Environment
import Epoxy
import SharedViews
import SwiftUI
import UIKit
import UIKitHelpers

public final class MealCategoryCollectionViewController: CollectionViewController {
  public struct State {
    var mealCategories = [ApiClient.MealCategory]()
    var cancellables = Set<AnyCancellable>()
    
    public init(
      mealCategories: [ApiClient.MealCategory] = [ApiClient.MealCategory](),
      cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    ) {
      self.mealCategories = mealCategories
      self.cancellables = cancellables
    }
  }
  
  private var state: State { didSet { setItems(items, animated: true) } }
  private var environment = Environment.shared
  
  public init(state: State) {
    self.state = state
    super.init(layout: UICollectionViewCompositionalLayout.grid(columns: 2))
    self.title = "Meal Categories"
    self.setItems(items, animated: false)
  }
  
  public override func viewDidLoad() {
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
              style: .large
            ),
            ImageMarquee.barModel(
              content: .init(imageURL: mealCategory.strCategoryThumb),
              style: .init(height: 100, contentMode: .scaleAspectFill)
            )
          ]
        ),
        style: .init(card: .init(
          cornerRadius: 12,
          borderWidth: 1
        ))
      )
      .didSelect { [weak self] _ in
        self?.environment.navigationStack.push(.mealCategory(mealCategory))
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct MealCategoryCollectionViewController_Previews: PreviewProvider {
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
