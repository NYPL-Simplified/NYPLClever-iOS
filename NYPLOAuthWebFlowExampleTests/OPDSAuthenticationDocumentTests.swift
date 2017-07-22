import XCTest
@testable import NYPLOAuthWebFlow

class OPDSAuthenticationDocumentTests: XCTestCase {

  let bundle = Bundle(for: OPDSAuthenticationTests.self)

  /// Returns a JSON object from the test bundle.
  private func object(_ name: String) -> Any {
    let url = bundle.url(forResource: name, withExtension: "json")!
    let data = try! Data(contentsOf: url, options: [])
    return try! JSONSerialization.jsonObject(with: data)
  }

  func testParse() {
    XCTAssertNotNil(OPDSAuthenticationDocument(jsonObject: object("OPDSAuthenticationDocumentTestsGood")))
  }
}
