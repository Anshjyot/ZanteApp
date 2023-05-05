import XCTest
@testable import Zante

class ZanteTests: XCTestCase {
  
  var sessionStore: SessionStore!
  
  override func setUpWithError() throws {
    sessionStore = SessionStore()
  }
  
  override func tearDownWithError() throws {
    sessionStore = nil
  }
  
  func testSessionStore() throws {
    XCTAssertNil(sessionStore.session) // If user session is nil
    
    // Sign in with user
    let expectation = XCTestExpectation(description: "Sign in user")
    authService.signIn(email: "test@example.com", password: "password") { error in
      XCTAssertNil(error)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 8.0)

    XCTAssertNotNil(sessionStore.session) // If the user session is not nil after signing in
    

    sessionStore.signOut() // Sign out the user

    XCTAssertNil(sessionStore.session) // Testing if the user session is nil after signing out
  }
  

}



