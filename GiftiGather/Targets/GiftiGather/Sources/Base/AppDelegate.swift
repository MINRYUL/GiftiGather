import UIKit
import DIContainer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    Injection.shared.injectionContainer()
    PhotoAuthManager.requestPhotosPermissionCheck()
    
    guard let homeViewController = HomeViewController.instantiate() else { return true }
    
    let navigationViewController = UINavigationController(rootViewController: homeViewController)
    
    window?.rootViewController = navigationViewController
    window?.makeKeyAndVisible()
    
    return true
  }

}

