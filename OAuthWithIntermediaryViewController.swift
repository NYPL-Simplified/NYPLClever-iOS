import UIKit

public final class OAuthWithIntermediaryViewController: UIViewController {

  public static let sharedInstance = OAuthWithIntermediaryViewController()

  private init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    self.view.backgroundColor = UIColor.white
  }

  public func authorize(
    documentURL: URL,
    providerURI: OPDSAuthenticationDocument.ProviderURI,
    successHandler: () -> Void,
    failureHandler: (Error) -> Void
  ) {
    let session = URLSession(configuration: .ephemeral)
    let tasks = session.dataTask(with: documentURL) { (data, response, error) in

    }
  }
}
