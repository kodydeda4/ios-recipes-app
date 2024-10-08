import AppFeature
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
  )
    -> Bool
  {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = AppViewController()
    window?.makeKeyAndVisible()
    return true
  }
 
}
