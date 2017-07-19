import XCTest
@testable import NYPLOAuthWebFlow

final class JSONTests: XCTestCase {

  func testEmpty() {
    let input = ["a": ["b": "c"]]
    let output = JSON.get(input, path: []) as! [String: [String: String]]
    XCTAssert(input == output)
  }

  func testSingle() {
    XCTAssertEqual(JSON.get(["a": ["b": "c"]], path: ["a"]) as! [String: String], ["b": "c"])
  }

  func testDouble() {
    XCTAssertEqual(JSON.get(["a": ["b": "c"]], path: ["a", "b"]) as! String, "c")
  }

  func testNil() {
    XCTAssertNil(JSON.get(["a": ["b": "c"]], path: ["a", "c"]))
  }
}

private func == <K, V>(a: [K: V], b: [K: V]) -> Bool {
  return NSDictionary(dictionary: a) == NSDictionary(dictionary: b)
}
