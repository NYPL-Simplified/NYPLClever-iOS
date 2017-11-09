import NYPLOAuthWebFlow
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
    -> Bool {

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = ViewController()
    self.window?.makeKeyAndVisible()

    return true
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {

    if url.scheme == "oauth-web-flow-example" {
      NYPLOAuthWebFlow.OAuthWithIntermediaryViewController.sharedInstance.resumeAfterRedirect(url: url)
      return true
    } else {
      return false
    }
  }
}
