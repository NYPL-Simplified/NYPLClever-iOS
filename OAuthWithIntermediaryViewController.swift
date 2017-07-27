import SafariServices
import UIKit

public protocol OAuthWithIntermediaryViewControllerDelegate: class {
  func oauthWithIntermediaryViewControllerDidCancel()
  func oauthWithIntermediaryViewControllerDidFail(withError error: Error?)
  func oauthWithIntermediaryViewControllerDidSucceed(withToken token: String)
}

public final class OAuthWithIntermediaryViewController: UIViewController {

  public static let sharedInstance = OAuthWithIntermediaryViewController()

  public weak var delegate: OAuthWithIntermediaryViewControllerDelegate?

  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

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
    redirectURL: URL,
    providerURI: OPDSAuthenticationDocument.ProviderURI) {

    let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)

    let task = session.dataTask(with: documentURL) { (data, response, error) in
      if let error = error {
        self.delegate?.oauthWithIntermediaryViewControllerDidFail(withError: error)
        return
      }

      if (response as! HTTPURLResponse).statusCode == 401 {
        guard
          let data = data,
          let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
          let document = OPDSAuthenticationDocument(jsonObject: jsonObject),
          let provider = document.providers[providerURI]
        else {
          self.delegate?.oauthWithIntermediaryViewControllerDidFail(withError: nil)
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
          self.delegate?.oauthWithIntermediaryViewControllerDidFail(withError: nil)
          return
        }

        var components = URLComponents(url: authorizeURL, resolvingAgainstBaseURL: false)
        components?.queryItems?.append(URLQueryItem(name: "redirect_uri", value: redirectURL.absoluteString))
        guard let url = components?.url else {
          self.delegate?.oauthWithIntermediaryViewControllerDidFail(withError: nil)
          return
        }

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
      } else {
        self.delegate?.oauthWithIntermediaryViewControllerDidFail(withError: nil)
      }
    }

    task.resume()
  }

  public func resumeAfterRedirect(url: URL) {
    guard
      let fragment = url.fragment,
      let queryItems = URLComponents(string: "?" + fragment)?.queryItems
    else {
      self.delegate?.oauthWithIntermediaryViewControllerDidFail(withError: nil)
      return
    }

    var query: [String: String] = [:]
    for item in queryItems {
      if let value = item.value {
        query[item.name] = value
      }
    }

    guard
      let accessToken = query["access_token"]
    else {
      self.delegate?.oauthWithIntermediaryViewControllerDidFail(withError:nil)
      return
    }

    self.delegate?.oauthWithIntermediaryViewControllerDidSucceed(withToken: accessToken)
  }
}

extension OAuthWithIntermediaryViewController: SFSafariViewControllerDelegate {

  public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    // Since this delegate method is called before the dismissal is complete, it is NOT safe to
    // call `self.cancelHandler` here as it may invoke another dismissal (and having two active
    // at the same time is not permissable). As such, we wait before calling the
    // handler. Since Apple's API is silly, this is the best we can do.
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
      self.delegate?.oauthWithIntermediaryViewControllerDidCancel()
    }
  }
}
