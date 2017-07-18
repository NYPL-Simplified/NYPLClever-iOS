import XCTest

class NYPLCleverDemoUITests: XCTestCase {

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()
  }
}
