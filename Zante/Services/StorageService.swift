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

          firestoreUserID.updateData([
            "profileImageUrl": metaImageURL, "username": username, "bio": bio
          ])
        }
        }
    }
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

  static func savePostPhoto(userId: String, caption: String, postId: String, imageData: Data, metadata: StorageMetadata, storagePostRef: StorageReference, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void ) {

      storagePostRef.putData(imageData, metadata: metadata) {
        (StorageMetadata, error) in

        if error != nil{
          onError(error!.localizedDescription)
          return
        }

        storagePostRef.downloadURL{
          (url, error) in
          if let metaImageURL = url?.absoluteString {
            let firestorePostRef = PostService.PostsUserId(userId: userId).collection("posts").document(postId)

            let post = PostModel.init(caption: caption, likes: [:], location: "", ownerId: userId, postId: postId, username: Auth.auth().currentUser!.displayName!, profile: Auth.auth().currentUser!.photoURL!.absoluteString, mediaUrl: metaImageURL, date: Date().timeIntervalSince1970, likeCount: 0)

            guard let dict = try? post.asDictionary() else {return}

            firestorePostRef.setData(dict) {
              (error) in
              if error != nil {
                onError(error!.localizedDescription)
                return
              }

              PostService.timelineUserId(userId: userId).collection("timeline").document(postId).setData(dict)

              PostService.AllPosts.document(postId).setData(dict)
              onSuccess()
            }
          }

        }

      }


    }

  static func saveChatPhoto(messageId: String, recipientId: String, recipientProfile: String, recipientName: String, senderProfile: String, senderId: String, senderUsername: String, imageData: Data, metaData: StorageMetadata, storageChatRef: StorageReference,
                            onSuccess: @escaping() -> Void, onError: @escaping(_ error: String) -> Void) {

    storageChatRef.putData(imageData, metadata: metaData) {
      (StorageMetadata, err) in

      if(err != nil) {
        onError(err!.localizedDescription)

        return
      }
      storageChatRef.downloadURL {
        (url, err) in
        if let metaImageURL = url?.absoluteString {
          let chat = ChatModel(messageId: messageId, textMessage: "", profile: senderProfile, photoUrl: metaImageURL, sender: senderId, username: senderUsername, timestamp: Date().timeIntervalSince1970, isPhoto: true)

          guard let dict = try? chat.asDictionary() else {return}
          ChatService.conversation(sender: senderId, recipient: recipientId).document(messageId).setData(dict) {
            (error) in
            if error == nil {
              ChatService.conversation(sender: recipientId, recipient: senderId).document(messageId).setData(dict)

              let senderMessage = MessageModel(lastMessage: "", username: senderUsername, isPhoto: true, timestamp: Date().timeIntervalSince1970, userId: senderId, profile: senderProfile)

              let recipientMessage = MessageModel(lastMessage: "", username: recipientName, isPhoto: false, timestamp: Date().timeIntervalSince1970, userId: recipientId, profile: recipientProfile)


              guard let senderDict = try? senderMessage.asDictionary() else {return}

              guard let recipientDict = try? recipientMessage.asDictionary() else {return}

              ChatService.messagesId(senderId: senderId, recipientId: recipientId).setData(senderDict)
              ChatService.messagesId(senderId: recipientId, recipientId: senderId).setData(recipientDict)

              onSuccess()
            } else {
              onError(error!.localizedDescription)
            }
              
            }
        }

      }
    }
    
  }

  }


