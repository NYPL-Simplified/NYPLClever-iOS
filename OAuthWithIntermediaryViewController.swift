import SafariServices
import UIKit

public final class OAuthWithIntermediaryViewController: UIViewController {

  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  fileprivate var cancelHandler: (() -> Void)?

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

    self.view.addSubview(self.activityIndicator)
    self.activityIndicator.color = UIColor.gray
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    View.centerInSuperview(self.activityIndicator)
    self.activityIndicator.startAnimating()
  }

  public func authorize(
    documentURL: URL,
    providerURI: OPDSAuthenticationDocument.ProviderURI,
    successHandler: @escaping () -> Void,
    failureHandler: @escaping (Error?) -> Void,
    cancelHandler: @escaping () -> Void) {

    let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)

    let task = session.dataTask(with: documentURL) { (data, response, error) in
      if let error = error {
        failureHandler(error)
        return
      }

      if (response as! HTTPURLResponse).statusCode == 401 {
        guard
          let data = data,
          let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
          let document = OPDSAuthenticationDocument(jsonObject: jsonObject),
          let provider = document.providers[providerURI]
        else {
          failureHandler(nil)
          return
        }

        guard
          let authorizeURL: URL = (provider.methods.reduce(nil) { (resultURL, method) in
            if resultURL != nil {
              return resultURL
            }
            switch method {
            case let .oauthWithIntermediary(authorizeURL):
              return authorizeURL
            default:
              return nil
            }
          })
        else {
          failureHandler(nil)
          return
        }

        self.cancelHandler = cancelHandler
        let safariViewController = SFSafariViewController(url: authorizeURL)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
      } else {
        failureHandler(nil)
      }
    }

    task.resume()
  }
}

extension OAuthWithIntermediaryViewController: SFSafariViewControllerDelegate {

  public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    // Since this delegate method is called before the dismissal is complete, it is NOT safe to
    // call `self.cancelHandler` here as it may invoke another dismissal (and having two active
    // at the same time is not permissable). As such, we wait a full second before calling the
    // handler. Since Apple's API is silly, this is the best we can do.
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      if let cancelHandler = self.cancelHandler {
        cancelHandler()
        self.cancelHandler = nil
      }
    }
  }
}
