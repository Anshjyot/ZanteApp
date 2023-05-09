//
//  SessionStore.swift
//  Zante
//
//  Created by Anshjyot Singh on 23/03/2023.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import FirebaseStorage

class SessionViewModel: ObservableObject {

  var didChange = PassthroughSubject<SessionViewModel, Never>() // A PassthroughSubject that emits events when the session view model changes
  @Published var session: User? {didSet{self.didChange.send(self)}} // The user session being managed by the view model
  var handle: AuthStateDidChangeListenerHandle? //  authentication state change listener

  func listen(){
    handle = Auth.auth().addStateDidChangeListener({(auth, user) in // listener for changes in users auth state
      if let user = user{ // If a user is logged in, fetch the data
        let firestoreUserId = AuthenticationViewModel.getUserID(userId: user.uid)
        firestoreUserId.getDocument{(document, error) in
          if let dict = document?.data(){
            // Converts doc data to User object and sets it as the session
            guard let decodedUser = try? User.init(fromDictionary: dict) else {return}
            self.session = decodedUser
          }
        }
      }

      else {
        self.session = nil // user not logged in
      }
    })
  }

  func logout() {
    do {
      try Auth.auth().signOut()
    }
    catch {

    }
  }

  func unbind(){ // removes the listener in regard to detect changes in auth
    if let handle = handle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
  }

  deinit { // deinitializer that is called when the object is destroyed
    unbind()

  }
}




