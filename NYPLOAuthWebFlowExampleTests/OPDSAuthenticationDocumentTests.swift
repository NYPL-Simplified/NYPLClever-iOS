import XCTest
@testable import NYPLOAuthWebFlow

class OPDSAuthenticationDocumentTests: XCTestCase {

  let bundle = Bundle(for: OPDSAuthenticationDocumentTests.self)

  /// Returns a JSON object from the test bundle.
  private func object(_ name: String) -> Any {
    let url = bundle.url(forResource: name, withExtension: "json")!
    let data = try! Data(contentsOf: url, options: [])
    return try! JSONSerialization.jsonObject(with: data)
  }

  func testGood() {
    XCTAssertNotNil(OPDSAuthenticationDocument(jsonObject: object("OPDSAuthenticationDocumentGood")))
  }

  func testNotAnObject() {
    XCTAssertNil(OPDSAuthenticationDocument(jsonObject: "foo"))
  }

  func testNoID() {
    XCTAssertNil(OPDSAuthenticationDocument(jsonObject: object("OPDSAuthenticationDocumentNoID")))
  }

  func testNoLinks() {
    XCTAssertNotNil(OPDSAuthenticationDocument(jsonObject: object("OPDSAuthenticationDocumentNoLinks")))
  }

  func testBadMethods() {
    XCTAssertNil(OPDSAuthenticationDocument(jsonObject: object("OPDSAuthenticationDocumentBadMethods")))
  }

  func testBadProvider() {
    XCTAssertNil(OPDSAuthenticationDocument(jsonObject: object("OPDSAuthenticationDocumentBadProvider")))
  }

  func testBadProviders() {
    XCTAssertNil(OPDSAuthenticationDocument(jsonObject: object("OPDSAuthenticationDocumentBadProviders")))
  }
}
