import XCTest

@testable import Zante
import SwiftUI

class ZanteUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testTextView() {
        let textView = app.textViews.firstMatch

        XCTAssertTrue(textView.value as! String == "")

        // Testing if the text can be edited
        textView.tap()
        textView.typeText("Hello, world!")
        XCTAssertTrue(textView.value as! String == "Hello, world!")
    }

    func testMessageButton() {
        let messageButton = app.buttons["messageButton"]
        XCTAssertTrue(messageButton.exists)  // Testing if the message button exists
        XCTAssertTrue(messageButton.isHittable)   // Message button is visible
        messageButton.tap()   // Can messageButton be tapped

    }
}

