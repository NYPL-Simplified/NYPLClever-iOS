import Foundation

final class OPDSAuthentication {

  /// Given a JSON object, returns the Clever authentication URL.
  static func cleverAuthenticateURLFromJSONObject(_ object: Any) -> URL? {

    guard let authenticateString =
      JSON.get(object, path: [
        "providers",
        "http://librarysimplified.org/terms/auth/clever",
        "methods",
        "http://librarysimplified.org/authtype/OAuth-with-intermediary",
        "links",
        "authenticate"]) as? String else { return nil }

    return URL(string: authenticateString)
  }
}
