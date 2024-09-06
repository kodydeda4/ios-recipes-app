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
      self?.makeExampleIndexViewController()
    }
    
    if let example = state.showExample {
      NavigationModel(
        dataID: DataID.item(example),
        makeViewController: { [weak self] in
          self?.makeExampleController(example)
        },
        remove: { [weak self] in
          self?.state.showExample = nil
        })
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
    viewController.title = "Epoxy"
    return viewController
  }
  
  private func makeExampleController(_ example: Example) -> UIViewController {
    let viewController: UIViewController
    
    switch example {
      
    case .product:
      viewController = ProductViewController()
      
    }
    
    viewController.title = example.title
    return viewController
  }
}

/// All top-level examples available in this project.
enum Example: CaseIterable {
  case product
  
  // MARK: Internal
  
  var title: String {
    switch self {
    case .product:
      return "Product Detail Page"
    }
  }
  
  var body: String {
    switch self {
    case .product:
      return "An example that combines collections, bars, and presentations"
    }
  }
}

