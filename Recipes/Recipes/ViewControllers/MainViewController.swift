import Epoxy
import UIKit

final class MainViewController: NavigationController {
  
  // MARK: Lifecycle
  
  init() {
    super.init(wrapNavigation: NavigationWrapperViewController.init(navigationController:))
    setStack(stack, animated: false)
  }
  
  // MARK: Private
  
  private enum DataID: Hashable {
    case index
    case item(Example)
  }
  
  private struct State {
    var showExample: Example?
  }
  
  private var state = State() {
    didSet { setStack(stack, animated: true) }
  }
  
  @NavigationModelBuilder private var stack: [NavigationModel] {
    NavigationModel.root(dataID: DataID.index) { [weak self] in
      MealListViewController()
    }
  }
  
  private func makeExampleIndexViewController() -> UIViewController {
    let viewController = CollectionViewController(
      layout: UICollectionViewCompositionalLayout.list,
      items: {
        Example.allCases.map { example in
          TextRow.itemModel(
            dataID: example,
            content: .init(title: example.title, body: example.body),
            style: .small)
          .didSelect { [weak self] _ in
            self?.state.showExample = example
          }
        }
      })
    viewController.title = "Recipes"
    return viewController
  }
  
  private func makeExampleController(_ example: Example) -> UIViewController {
    let viewController: UIViewController
    
    switch example {
      
    case .product:
      viewController = ProductViewController()
      
    case .mealList:
      viewController = MealListViewController()
      
    }
    
    viewController.title = example.title
    return viewController
  }
}

/// All top-level examples available in this project.
enum Example: CaseIterable {
  case product
  case mealList
  
  // MARK: Internal
  
  var title: String {
    switch self {
    case .product:
      return "Product Detail Page"
    case .mealList:
      return "Meal List Page"
    }
  }
  
  var body: String {
    switch self {
    case .product:
      return "An example that combines collections, bars, and presentations"
    case .mealList:
      return "An example that fetches models from an api."
    }
  }
}
