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

    var testvar: LogInView!

    override func setUp() {
        super.setUp()
        testvar = LogInView()
    }

    override func tearDown() {
        testvar = nil
        super.tearDown()
    }

    func testLoginForm() {
        // Test valid login
        testvar.email = "validemail@example.com"
        testvar.password = "password123"
        testvar.logIn()
        // You can assert here that the user is logged in successfully

        // Test empty email
        testvar.email = ""
        testvar.password = "password123"
        testvar.logIn()
        XCTAssert(testvar.error == "Please fill in all boxes")
        XCTAssert(testvar.showingAlert == true)

        // Test empty password
        testvar.email = "validemail@example.com"
        testvar.password = ""
        testvar.logIn()
        XCTAssert(testvar.error == "Please fill in all boxes")
        XCTAssert(testvar.showingAlert == true)

    }
}
