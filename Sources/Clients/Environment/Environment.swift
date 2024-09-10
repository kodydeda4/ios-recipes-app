import ApiClient
import NavigationControllerClient
import SwiftUI

/// The current environment of dependencies within the app.
public final class Environment {
  public static var shared = Environment()
  private init() {}

  public var api = ApiClient.liveValue
  public var navigationStack = NavigationControllerClient.unimplemented
  public var mainQueue = DispatchQueue.main
}


