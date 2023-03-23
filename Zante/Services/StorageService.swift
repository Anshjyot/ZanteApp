//
//  StorageService.swift
//  Zante
//
//  Created by Anshjyot Singh on 19/03/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage



class StorageService {

  static var storage = Storage.storage()

  static var storageRoot = storage.reference(forURL: "gs://zante-cbd70.appspot.com")

  static var storageProfile = storageRoot.child("profile")

  static func storageProfileID(userId: String) -> StorageReference {
    return storageProfile.child(userId)
  }

  static func saveProfileImage(userId: String, username: String, email: String, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void ) {

    storageProfileImageRef.putData(imageData, metadata: metaData) {
      (StorageMetadata, error) in

      if error != nil{
        onError(error!.localizedDescription)
        return
      }

      storageProfileImageRef.downloadURL{
        (url, error) in
        if let metaImageURL = url?.absoluteString {

          if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.photoURL = url
            changeRequest.displayName = username
            changeRequest.commitChanges{
              (error) in
              if error != nil{
                onError(error!.localizedDescription)
                return
              }
            }
          }

          let firestoreUserID = AuthService.getUserID(userId: userId)
          let user = User.init(uid: userId, email: email, profileImageURL: metaImageURL, userName: username, seachName: username.splitString(), bio: "")

          guard let dict = try?user.asDictionary() else {return}

          firestoreUserID.setData(dict){
            (error) in
            if error != nil {
              onError(error!.localizedDescription)
            }

          }

          onSuccess(user)
        }
      }
    }
  }
}

