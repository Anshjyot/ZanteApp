//
//  LoginViewTest.swift
//  ZanteUITests
//
//  Created by Vandad Azar on 04/05/2023.
//

import Foundation
import XCTest
@testable import Zante

class LoginViewTest: XCTestCase {

    var test: LogInView!

    override func setUp() {
        super.setUp()
        test = LogInView()
    }

    override func tearDown() {
        test = nil
        super.tearDown()
    }

    func testLoginForm() {
        // Test valid login
        test.email = "zante@gmail.com"
        test.password = "zante123"
        test.logIn()


        // Testing empty email
        test.email = ""
        test.password = "password"
        test.logIn()
        XCTAssert(test.error == "Please fill in all boxes")
        XCTAssert(test.showingAlert == true)

        // Testing empty password
        test.email = "mail@example.com"
        test.password = ""
        test.logIn()
        XCTAssert(test.error == "Please fill in all boxes")
        XCTAssert(test.showingAlert == true)

    }
}
