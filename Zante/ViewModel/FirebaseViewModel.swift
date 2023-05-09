//
//  StorageService.swift
//  Zante
//
//  Created by Anshjyot Singh on 19/03/2023.
//https://stackoverflow.com/questions/67318879/swift-and-firebase-value-of-type-user-has-no-member-asdict

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage



class FirebaseViewModel {

  static var storage = Storage.storage()

  static var storageRoot = storage.reference()

  static var storageProfile = storageRoot.child("profile")

  static var storagePost = storageRoot.child("posts")

  static var storageChat = storageRoot.child("chat")

  static func storagePostID(postId: String) -> StorageReference {
    return storagePost.child(postId)
  }

  static func storagechatID(chatId: String) -> StorageReference {
    return storageChat.child(chatId)
  }


  static func storageProfileID(userId: String) -> StorageReference {
    return storageProfile.child(userId)
  }

  static func editProfile(userId: String, username: String, bio: String, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onError: @escaping(_ errorMessage: String) -> Void) {

    storageProfileImageRef.putData(imageData, metadata: metaData) { // storage reference to upload the new profile image data to Firebase Storage.
      (StorageMetadata, error) in

      if error != nil{
        onError(error!.localizedDescription)
        return
      }

      storageProfileImageRef.downloadURL{ // retrieves the download URL for the new image.
        (url, error) in
        if let metaImageURL = url?.absoluteString {

          if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() { //
            // update the userprofile  with the new username and profile image URL.
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

          let firestoreUserID = AuthenticationViewModel.getUserID(userId: userId) // ref user's document in Firestore using their uid

          firestoreUserID.updateData([ // updates the user's profile
            "profileImageUrl": metaImageURL, "username": username, "bio": bio // document's fields
          ])
        }
        }
    }
  }

  static func fetchAllUsers(onSuccess: @escaping(_ users: [User]) -> Void) {
    AuthenticationViewModel.storeRoot.collection("users").getDocuments { (snapshot, error) in
          guard let snap = snapshot else { // Check if there was an error fetching the users.
              print("Error fetching users")
              return
          }

          var users = [User]() // empty array of users to store the fetched users.

          for doc in snap.documents { // each document in the 'users' collection.
              let dict = doc.data() // data for the current document as a dictionary.
              guard let decoder = try? User.init(fromDictionary: dict) else { // decode the data into a User object.
                  return
              }

              users.append(decoder) // Add the decoded User object to the array of users.
          }

          onSuccess(users) // closure fetched user
      }
  }

  static func saveProfileImage(userId: String, username: String, email: String, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void ) {

    storageProfileImageRef.putData(imageData, metadata: metaData) { // upload the image data to Firebase Storage with the ref
      (StorageMetadata, error) in

      if error != nil{
        onError(error!.localizedDescription)
        return
      }

      storageProfileImageRef.downloadURL{ // retrieve the download URL
        (url, error) in
        if let metaImageURL = url?.absoluteString {



          let firestoreUserID = AuthenticationViewModel.getUserID(userId: userId) // get a ref to user doc
          let user = User.init(uid: userId, email: email, profileImageURL: metaImageURL, userName: username, searchName: username.splitString(), bio: "") // user object with the updated profile information

          guard let dict = try?user.asDictionary() else {return} // convert the user object to a dictionary

          firestoreUserID.setData(dict){ // save the user's information
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

  static func savePostPhoto(userId: String, caption: String, postId: String, imageData: Data, metadata: StorageMetadata, storagePostRef: StorageReference, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void ) {
      // Fetch the user's data from Firestore
    AuthenticationViewModel.getUserID(userId: userId).getDocument { (document, error) in
          if let error = error {
              onError(error.localizedDescription)
              return
          }
          guard let document = document, document.exists, let userData = document.data() else { // 
              onError("Error fetching user data.")
              return
          }

          // Get the username and profile URL from the fetched data
        guard let username = userData["userName"] as? String else {
            onError("Error getting username from user data. Data: \(userData)")
            return
        }
        guard let profile = userData["profileImageURL"] as? String else {
            onError("Error getting profile URL from user data. Data: \(userData)")
            return
        }



          // Upload the image
          storagePostRef.putData(imageData, metadata: metadata) {
              (StorageMetadata, error) in

              if error != nil{
                  onError(error!.localizedDescription)
                  return
              }

              storagePostRef.downloadURL{ // Get the download URL for the image and create a new post object
                  (url, error) in
                  if let metaImageURL = url?.absoluteString {
                      let firestorePostRef = PostingViewModel.PostsUserId(userId: userId).collection("posts").document(postId)

                      let post = PostModel.init(caption: caption, likes: [:], location: "", ownerId: userId, postId: postId, username: username, profile: profile, mediaUrl: metaImageURL, date: Date().timeIntervalSince1970, likeCount: 0)
                    // create a new post object

                      guard let dict = try? post.asDictionary() else {return} // convert the post object to a dictionary for saving to Firestore

                      firestorePostRef.setData(dict) { // saving the new post to Firestore
                          (error) in
                          if error != nil {
                              onError(error!.localizedDescription)
                              return
                          }

                        // now adding the new post to the user's timeline and all posts collections
                        PostingViewModel.timelineUserId(userId: userId).collection("timeline").document(postId).setData(dict)

                        PostingViewModel.AllPosts.document(postId).setData(dict)
                          onSuccess()
                      }
                  }

              }

          }
      }
  }



  static func saveChatPhoto(messageId: String, recipientId: String, recipientProfile: String, recipientName: String, senderProfile: String, senderId: String, senderUsername: String, imageData: Data, metaData: StorageMetadata, storageChatRef: StorageReference,
                            onSuccess: @escaping() -> Void, onError: @escaping(_ error: String) -> Void) {

    storageChatRef.putData(imageData, metadata: metaData) { // Upload the image data to Firebase Storage
      (StorageMetadata, err) in

      if(err != nil) {
        onError(err!.localizedDescription)

        return
      }
      storageChatRef.downloadURL { // Get the download URL for the image
        (url, err) in
        if let metaImageURL = url?.absoluteString {
          let chat = ChatModel(messageId: messageId, textMessage: "", profile: senderProfile, photoUrl: metaImageURL, sender: senderId, username: senderUsername, timestamp: Date().timeIntervalSince1970, isPhoto: true)

          guard let dict = try? chat.asDictionary() else {return}
          ChatViewModel.conversation(sender: senderId, recipient: recipientId).document(messageId).setData(dict) {
            // Saving the chat message with the image URL to Firestore
            (error) in
            if error == nil {
              ChatViewModel.conversation(sender: recipientId, recipient: senderId).document(messageId).setData(dict)
              // Now we save the same chat message to the recipient's conversation

              let senderMessage = MessageModel(lastMessage: "", username: senderUsername, isPhoto: true, timestamp: Date().timeIntervalSince1970, userId: senderId, profile: senderProfile)

              let recipientMessage = MessageModel(lastMessage: "", username: recipientName, isPhoto: false, timestamp: Date().timeIntervalSince1970, userId: recipientId, profile: recipientProfile)


              guard let senderDict = try? senderMessage.asDictionary() else {return}

              guard let recipientDict = try? recipientMessage.asDictionary() else {return}

              ChatViewModel.messagesId(senderId: senderId, recipientId: recipientId).setData(senderDict) // Save the message with image url
              ChatViewModel.messagesId(senderId: recipientId, recipientId: senderId).setData(recipientDict)

              onSuccess()
            } else {
              onError(error!.localizedDescription)
            }

            }
        }

      }
    }

  }

  static func saveAudioPost(userId: String, caption: String, postId: String, audioData: Data, metadata: StorageMetadata, storagePostRef: StorageReference, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
      storagePostRef.putData(audioData, metadata: metadata) { (storageMetaData, error) in // Upload the audio data to Firebase Storage
          if error != nil {
              onError(error!.localizedDescription)
              return
          }

          storagePostRef.downloadURL { (url, error) in // Download URL for audio and create a new post object
              if let metaImageUrl = url?.absoluteString {
                  let firestorePostRef = PostingViewModel.PostsUserId(userId: userId).collection("posts").document(postId)

                  let postModel = PostModel(caption: caption, likes: [String: Bool](), location: "", ownerId: userId, postId: postId, username: "", profile: "", mediaUrl: metaImageUrl, date: Date().timeIntervalSince1970, likeCount: 0, mediaType: "audio")

                guard let dict = try? postModel.toDictionary() else { // Convert the post object to a dictionary
                    onError("Error converting PostModel to dictionary")
                    return
                }


                  firestorePostRef.setData(dict) { (error) in   // Save the new post to Firestore
                      if error != nil {
                          onError(error!.localizedDescription)
                          return
                      }

                      onSuccess()
                  }
              }
          }
      }
  }

  }



