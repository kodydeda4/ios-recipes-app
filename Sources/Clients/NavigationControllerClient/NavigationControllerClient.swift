import ApiClient
import Foundation

/// A simple dependnecy to push/pop views from the root NavigationController.
/// Note: This property must be overwritten in the actual NavigationController to have any affect.
public struct NavigationControllerClient {
  public var push: (Path) -> Void = { _ in }
  public var pop: () -> Void = {}

  public enum Path {
    case mealCategory(ApiClient.MealCategory)
    case mealDetails(ApiClient.MealDetails)
  }
}

extension NavigationControllerClient {
  public static var unimplemented = Self(
    push: { _ in fatalError("NavigationControllerClient.push is unimplemented.") },
    pop: { fatalError("NavigationControllerClient.pop is unimplemented.") }
  )
}
