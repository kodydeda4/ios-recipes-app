import UIKit

final class NavigationWrapperViewController: UIViewController {
  init(navigationController: UINavigationController) {
    navigationController.setNavigationBarHidden(true, animated: false)
    
    super.init(nibName: nil, bundle: nil)
    
    addChild(navigationController)
    view.addSubview(navigationController.view)
    navigationController.view.frame = view.bounds
    navigationController.view.translatesAutoresizingMaskIntoConstraints = true
    navigationController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    navigationController.didMove(toParent: self)
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
