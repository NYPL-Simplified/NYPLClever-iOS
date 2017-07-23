import UIKit

public final class OAuthWithIntermediaryViewController: UIViewController {

  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

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
  }

  public func authorize(
    documentURL: URL,
    providerURI: OPDSAuthenticationDocument.ProviderURI,
    successHandler: @escaping () -> Void,
    failureHandler: @escaping (Error?) -> Void) {

    let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)

    let task = session.dataTask(with: documentURL) { (data, response, error) in
      self.activityIndicator.stopAnimating()

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

        print(authorizeURL)
      } else {
        failureHandler(nil)
      }
    }

    self.activityIndicator.startAnimating()
    task.resume()
  }
}
