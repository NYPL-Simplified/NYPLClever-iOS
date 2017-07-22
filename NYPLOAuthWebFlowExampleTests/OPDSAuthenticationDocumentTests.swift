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

  func testBad() {
    XCTAssertNil(OPDSAuthenticationDocument(jsonObject: object("OPDSAuthenticationDocumentBad")))
  }
}
