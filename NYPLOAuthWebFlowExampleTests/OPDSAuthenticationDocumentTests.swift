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

  func testLinkConstruction() {
    XCTAssertEqual(
      OPDSAuthenticationDocument.LinkKey(string: "copyright"),
      OPDSAuthenticationDocument.LinkKey.copyright)

    XCTAssertEqual(
      OPDSAuthenticationDocument.LinkKey(string: "privacy-policy"),
      OPDSAuthenticationDocument.LinkKey.privacyPolicy)

    XCTAssertEqual(
      OPDSAuthenticationDocument.LinkKey(string: "terms-of-service"),
      OPDSAuthenticationDocument.LinkKey.termsOfService)

    XCTAssertEqual(
      OPDSAuthenticationDocument.LinkKey(string: "other"),
      OPDSAuthenticationDocument.LinkKey.unrecognized(string: "other"))
  }

  func testLinkStrings() {
    XCTAssertEqual(OPDSAuthenticationDocument.LinkKey(string: "copyright").string, "copyright")

    XCTAssertEqual(OPDSAuthenticationDocument.LinkKey(string: "privacy-policy").string, "privacy-policy")

    XCTAssertEqual(OPDSAuthenticationDocument.LinkKey(string: "terms-of-service").string, "terms-of-service")

    XCTAssertEqual(OPDSAuthenticationDocument.LinkKey(string: "other").string, "other")
  }

  func testLinkNoHref() {
    XCTAssertNil(OPDSAuthenticationDocument.Link(jsonObject: [:]))
  }

  func testLinkNoType() {
    let link = OPDSAuthenticationDocument.Link(jsonObject: ["href": "http://example.com"])
    XCTAssertNotNil(link)
    XCTAssertNil(link?.type)
  }

  func testLinkTextHtml() {
    let link = OPDSAuthenticationDocument.Link(jsonObject: ["href": "http://example.com", "type": "text/html"])
    XCTAssert(link!.type! == OPDSAuthenticationDocument.LinkType.textHTML)
  }

  func testLinkTypeUnrecognized() {
    let link = OPDSAuthenticationDocument.Link(jsonObject: ["href": "http://example.com", "type": "foo"])
    XCTAssert(link!.type! == OPDSAuthenticationDocument.LinkType.unrecognized(string: "foo"))
  }
}
