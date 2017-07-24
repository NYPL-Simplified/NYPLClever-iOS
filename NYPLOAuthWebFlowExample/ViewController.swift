import NYPLOAuthWebFlow
import UIKit

class ViewController: UIViewController {

  override func viewDidAppear(_ animated: Bool) {

    // NOTE: Due to a bug in iOS 10, it is NOT safe to call `authorize` while a presentation
    // animation is currently taking place. As such, we call it here only after the presentation
    // has completed. See http://www.openradar.me/29108332 for more information.
    self.present(
      OAuthWithIntermediaryViewController.sharedInstance,
      animated: true,
      completion: {
        OAuthWithIntermediaryViewController.sharedInstance.authorize(
          documentURL: URL(string: "https://circulation.openebooks.us")!,
          providerURI: OPDSAuthenticationDocument.ProviderURI.clever,
          successHandler: {

          },
          failureHandler: { error in

          },
          cancelHandler: {
            OAuthWithIntermediaryViewController.sharedInstance.dismiss(animated: true, completion: nil)
          }
        )
      }
    )
  }
}
