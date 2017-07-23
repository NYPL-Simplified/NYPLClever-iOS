import NYPLOAuthWebFlow
import UIKit

class ViewController: UIViewController {

  override func viewDidAppear(_ animated: Bool) {
    self.present(OAuthWithIntermediaryViewController.sharedInstance, animated: true, completion: nil)
  }
}
