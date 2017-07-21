import Foundation

public struct OPDSAuthenticationDocument {

  let id: String
  let links: [LinkKey: Link?]
  let name: String?
  let providers: [ProviderURI: Provider]

  init?(jsonObject: Any) {
    guard let dict = jsonObject as? [String: Any] else { return nil }

    guard let id = dict["id"] as? String else { return nil }
    self.id = id

    if let linksDict = dict["links"] as? [String: Any] {
      var links: [LinkKey: Link?] = [:]
      for (k, v) in linksDict {
        links[LinkKey(string: k)] = Link(jsonObject: v)
      }
      self.links = links
    } else {
      self.links = [:]
    }

    self.name = dict["name"] as? String

    guard let providersDict = dict["providers"] as? [String: Any] else { return nil }
    var providers: [ProviderURI: Provider] = [:]
    for (providerURIString, providerJSONObject) in providersDict {
      guard let providerDict = providerJSONObject as? [String: Any] else { return nil }
      guard let methodsDict = providerDict["methods"] as? [String: Any] else { return nil }
      let methods = methodsDict.map { (methodURIString, methodJSONObject) in
        Method(uri: MethodURI(string: methodURIString), jsonObject: methodJSONObject)
      }
      providers[ProviderURI(string: providerURIString)] =
        Provider(methods: methods, name: providerDict["name"] as? String)
    }
    self.providers = providers
  }

  enum LinkKey: Hashable {
    case copyright
    case privacyPolicy
    case termsOfService
    case unrecognized(string: String)

    private static let copyrightString = "copyright"
    private static let privacyPolicyString = "privacyPolicy"
    private static let termsOfServiceString = "termsOfService"

    init(string: String) {
      switch string {
      case LinkKey.copyrightString:
        self = .copyright
      case LinkKey.privacyPolicyString:
        self = .privacyPolicy
      case LinkKey.termsOfServiceString:
        self = .termsOfService
      default:
        self = .unrecognized(string: string)
      }
    }

    var string: String {
      switch self {
      case .copyright:
        return LinkKey.copyrightString
      case .privacyPolicy:
        return LinkKey.privacyPolicyString
      case .termsOfService:
        return LinkKey.termsOfServiceString
      case let .unrecognized(string):
        return string
      }
    }

    var hashValue: Int {
      switch self {
      case .copyright:
        return 0
      case .privacyPolicy:
        return 1
      case .termsOfService:
        return 2
      case let .unrecognized(key):
        return key.hashValue
      }
    }
  }

  struct Link {
    let href: URL
    let type: LinkType?

    init?(jsonObject: Any) {
      guard
        let dict = jsonObject as? [String: String],
        let hrefString = dict["href"],
        let href = URL(string: hrefString)
        else { return nil }
      self.href = href
      if let type = dict["type"] {
        self.type = LinkType(string: type)
      } else {
        self.type = nil
      }
    }
  }

  enum LinkType {
    case textHTML
    case unrecognized(string: String)

    private static let textHTMLString = "text/html"

    init(string: String) {
      switch string {
      case LinkType.textHTMLString:
        self = .textHTML
      default:
        self = .unrecognized(string: string)
      }
    }

    var string: String {
      switch self {
      case .textHTML:
        return LinkType.textHTMLString
      case let .unrecognized(string):
        return string
      }
    }
  }

  enum ProviderURI: Hashable {
    case clever
    case libraryBarcode
    case unrecognized(string: String)

    private static let cleverString = "http://librarysimplified.org/terms/auth/clever"
    private static let libraryBarcodeString = "http://librarysimplified.org/terms/auth/library-barcode"

    init(string: String) {
      switch string {
      case ProviderURI.cleverString:
        self = .clever
      case ProviderURI.libraryBarcodeString:
        self = .libraryBarcode
      default:
        self = .unrecognized(string: string)
      }
    }

    var string: String {
      switch self {
      case .clever:
        return ProviderURI.cleverString
      case .libraryBarcode:
        return ProviderURI.libraryBarcodeString
      case let .unrecognized(string):
        return string
      }
    }

    var hashValue: Int {
      switch self {
      case .clever:
        return 0
      case .libraryBarcode:
        return 1
      case let .unrecognized(string):
        return string.hashValue
      }
    }
  }

  enum MethodURI {
    case basicAuth
    case oauthWithIntermediary
    case unrecognized(string: String)

    private static let basicAuthString = "http://opds-spec.org/auth/basic"
    private static let oauthWithIntermediaryString = "http://librarysimplified.org/authtype/OAuth-with-intermediary"

    init(string: String) {
      switch string {
      case MethodURI.basicAuthString:
        self = .basicAuth
      case MethodURI.oauthWithIntermediaryString:
        self = .oauthWithIntermediary
      default:
        self = .unrecognized(string: string)
      }
    }

    var string: String {
      switch self {
      case .basicAuth:
        return MethodURI.basicAuthString
      case .oauthWithIntermediary:
        return MethodURI.oauthWithIntermediaryString
      case let .unrecognized(string):
        return string
      }
    }
  }

  enum Method {
    case basicAuth(loginLabel: String, passwordLabel: String)
    case oauthWithIntermediary(authenticateURL: URL)
    case unrecognized(uri: MethodURI, jsonObject: Any)

    init(uri: MethodURI, jsonObject: Any) {
      switch uri {
      case .basicAuth:
        guard
          let dict = jsonObject as? [String: [String: String]],
          let labels = dict["labels"],
          let login = labels["login"],
          let password = labels["password"]
          else { self = .unrecognized(uri: uri, jsonObject: jsonObject); return }
        self = .basicAuth(loginLabel: login, passwordLabel: password)
      case .oauthWithIntermediary:
        guard
          let dict = jsonObject as? [String: [String: String]],
          let links = dict["links"],
          let authenticateString = links["authenticate"],
          let authenticateURL = URL(string: authenticateString)
          else { self = .unrecognized(uri: uri, jsonObject: jsonObject); return }
        self = .oauthWithIntermediary(authenticateURL: authenticateURL)
      case .unrecognized:
        self = .unrecognized(uri: uri, jsonObject: jsonObject)
      }
    }
  }

  struct Provider {
    let methods: [Method]
    let name: String?
  }
}

func == (a: OPDSAuthenticationDocument.LinkKey, b: OPDSAuthenticationDocument.LinkKey) -> Bool {
  switch (a, b) {
  case (.copyright, .copyright):
    return true
  case (.privacyPolicy, .privacyPolicy):
    return true
  case (.termsOfService, .termsOfService):
    return true
  case let (.unrecognized(keyA), .unrecognized(keyB)):
    return keyA == keyB
  default:
    return false
  }
}

func == (a: OPDSAuthenticationDocument.ProviderURI, b: OPDSAuthenticationDocument.ProviderURI) -> Bool {
  switch (a, b) {
  case (.clever, .clever):
    return true
  case (.libraryBarcode, .libraryBarcode):
    return true
  case let (.unrecognized(uriA), .unrecognized(uriB)):
    return uriA == uriB
  default:
    return false
  }
}
