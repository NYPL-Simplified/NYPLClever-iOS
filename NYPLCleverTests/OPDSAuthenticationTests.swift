import XCTest
@testable import NYPLClever

final class OPDSAuthenticationTests: XCTestCase {

  let bundle = Bundle(for: OPDSAuthenticationTests.self)

  /// Returns a JSON object from the test bundle.
  private func object(_ name: String) -> Any {
    let url = bundle.url(forResource: name, withExtension: "json")!
    let data = try! Data(contentsOf: url, options: [])
    return try! JSONSerialization.jsonObject(with: data)
  }

  func testGood() {
    let object = self.object("OPDSAuthenticationTestsGood")
    XCTAssertEqual(
      OPDSAuthentication.cleverAuthenticateURLFromJSONObject(object),
      URL(string: "https://circulation.openebooks.us/oauth_authenticate?provider=Clever"))
  }

  func testBad0() {
    let object = self.object("OPDSAuthenticationTestsBad0")
    XCTAssertNil(OPDSAuthentication.cleverAuthenticateURLFromJSONObject(object))
  }

  func testBad1() {
    let object = self.object("OPDSAuthenticationTestsBad1")
    XCTAssertNil(OPDSAuthentication.cleverAuthenticateURLFromJSONObject(object))
  }
}
