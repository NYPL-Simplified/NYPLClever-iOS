import NYPLOAuthWebFlow
import UIKit

class ViewController: UIViewController {

  override func viewDidAppear(_ animated: Bool) {

    OAuthWithIntermediaryViewController.sharedInstance.delegate = self

    // NOTE: Due to a bug in iOS 10, it is NOT safe to call `authorize` while a presentation
    // animation is currently taking place. As such, we call it here only after the presentation
    // has completed. See http://www.openradar.me/29108332 for more information.
    self.present(
      OAuthWithIntermediaryViewController.sharedInstance,
      animated: true,
      completion: {
        OAuthWithIntermediaryViewController.sharedInstance.authorize(
          documentURL: URL(string: "https://circulation.openebooks.us")!,
          redirectURL: URL(string: "oauth-web-flow-example://oauth")!,
          providerURI: OPDSAuthenticationDocument.ProviderURI.clever)
      }
    )
  }
}

extension ViewController: OAuthWithIntermediaryViewControllerDelegate {

  func oauthWithIntermediaryViewControllerDidCancel() {
    print("Cancelled")
    self.dismiss(animated: true, completion: nil)
  }

  func oauthWithIntermediaryViewControllerDidFail(withError error: Error?) {
    let message: String = {
      if let description = error?.localizedDescription {
        return description
      } else {
        return NSLocalizedString("An unknown error occurred. Please try again later.", comment: "")
      }
    }()

    let alertController = UIAlertController(title: NSLocalizedString("Error Signing In", comment: ""),
                                            message: message,
                                            preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))

    self.present(alertController, animated: true, completion: nil)
  }

  func oauthWithIntermediaryViewControllerDidSucceed(withToken token: String) {
    print(token)
    self.dismiss(animated: true, completion: nil)
  }
}
