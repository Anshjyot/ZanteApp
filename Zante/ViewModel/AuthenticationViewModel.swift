//
//  AuthService.swift
//  Zante
//
//  Created by Anshjyot Singh on 19/03/2023.
//https://www.youtube.com/watch?v=-pAQcPolruw&list=PLimqJDzPI-H9u3cSJCPB_EJsTU8XP2NUT
// https://stackoverflow.com/questions/67964816/trying-to-fetch-data-from-firestore-coming-up-as-nil-with-swiftui

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AuthenticationViewModel {

  static var storeRoot = Firestore.firestore()

  static func getUserID(userId: String) -> DocumentReference{
    return storeRoot.collection("users").document(userId)
  }

  static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void ) { // closure
    Auth.auth().createUser(withEmail: email, password: password) {
      (authData, error) in

      if error != nil { // localized error by firebase
        onError(error!.localizedDescription)
        return
      }

      // success

      guard let userId = authData?.user.uid else {return}  //unique ID from the returned authData

      let storageProfileUserId = FirebaseViewModel.storageProfileID(userId: userId)      // unique storage path for the user's profile image.

      let metadata = StorageMetadata()  // save the image to Firebase Storage and create a new user in the Firestore database.
      metadata.contentType = "image/jpg"

      FirebaseViewModel.saveProfileImage(userId: userId, username: username, email: email, imageData: imageData, metaData: metadata, storageProfileImageRef: storageProfileUserId, onSuccess: onSuccess, onError: onError)
    }

  }


  static func logIn(email: String, password: String, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void ) { Auth.auth().signIn(withEmail: email, password: password) {
    (authData, error) in

    if error != nil { // error
      onError(error!.localizedDescription)
      return
    }

    // success

    guard let userId = authData?.user.uid else {return} // authData object contains the uid from the authenticated user

    let firestoreUserId = getUserID(userId: userId) // uid used to retrieve the user's data from the Firestore database
    firestoreUserId.getDocument{
      (document, error) in
      if let dict = document?.data(){
        guard let decodedUser = try? User.init(fromDictionary: dict) else {return}  // decoded into a User object
        onSuccess(decodedUser) // passed to the onSuccess closure
      }
    }
  }
  }
}

