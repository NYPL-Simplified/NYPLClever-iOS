import NYPLOAuthWebFlow
import UIKit

class ViewController: UIViewController {

  override func viewDidAppear(_ animated: Bool) {
    self.present(OAuthWithIntermediaryViewController.sharedInstance, animated: true, completion: nil)

    OAuthWithIntermediaryViewController.sharedInstance.authorize(
      documentURL: URL(string: "https://circulation.openebooks.us")!,
      providerURI: OPDSAuthenticationDocument.ProviderURI.clever,
      successHandler: {

      },
      failureHandler: { error in

      }
    )
  }
}
