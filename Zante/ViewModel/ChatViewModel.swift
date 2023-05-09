//
//  ChatService.swift
//  Zante
//
//  Created by Anshjyot Singh on 10/04/2023.
//https://www.youtube.com/watch?v=dA_Ve-9gizQ

import Foundation
import Firebase
import FirebaseStorage

class ChatViewModel: ObservableObject {

  @Published var isLoading = false
  @Published var chats: [ChatModel] = []

  var listener: ListenerRegistration!
  var recipientId = ""

  static var chats = AuthenticationViewModel.storeRoot.collection("chats")
  static var messages = AuthenticationViewModel.storeRoot.collection("messages")

  static func conversation(sender: String, recipient: String) -> CollectionReference {
    return chats.document(sender).collection("chats").document(recipient).collection("conversation")
  }

  static func userMessages(userId: String) -> CollectionReference {
    return messages.document(userId).collection("messages")
  }

  static func messagesId(senderId: String, recipientId: String) -> DocumentReference {
    return messages.document(senderId).collection("messages").document(recipientId)
  }

  func loadChats() {
    self.chats = [] // Clear chats
    self.isLoading = true

    self.getChats(userId: recipientId, onSuccess: {
      (chats) in
      if self.chats.isEmpty{
        self.chats = chats // loaded chats
      }
    }, onError: {
      (err) in
      print("Error \(err)")
    }, newChat: {
      (chat) in
      if !self.chats.isEmpty{ // append new chat
        self.chats.append(chat)
      }
    }) {
      (listener) in // to update
      self.listener = listener
    }
  }

  func sendMessage(message: String, recipientId: String, recipientProfile: String, recipientName: String,
                     onSuccess: @escaping() -> Void, onError: @escaping(_ error: String) -> Void) {
      // get sender information
      guard let senderId = Auth.auth().currentUser?.uid else {return}
      guard let senderUsername = Auth.auth().currentUser?.displayName else {return}
      guard let senderProfile = Auth.auth().currentUser?.photoURL!.absoluteString else {return}

      // generate message ID and create chat object
      let messageId = ChatViewModel.conversation(sender: senderId, recipient: recipientId).document().documentID
      let chat = ChatModel(messageId: messageId, textMessage: message, profile: senderProfile, photoUrl: "", sender: senderId, username: senderUsername, timestamp: Date().timeIntervalSince1970, isPhoto: false)

      // converting chat object to dictionary to save it to Firebase
      guard let dict = try? chat.asDictionary() else {return}
      ChatViewModel.conversation(sender: senderId, recipient: recipientId).document(messageId).setData(dict) {
        (error) in
        if error == nil {
          // save the same chat object to the recipient's conversation
          ChatViewModel.conversation(sender: recipientId, recipient: senderId).document(messageId).setData(dict)

          //  message objects for the sender and recipient
          let senderMessage = MessageModel(lastMessage: message, username: senderUsername, isPhoto: false, timestamp: Date().timeIntervalSince1970, userId: senderId, profile: senderProfile)

          let recipientMessage = MessageModel(lastMessage: message, username: recipientName, isPhoto: false, timestamp: Date().timeIntervalSince1970, userId: recipientId, profile: recipientProfile)

          // converting message objects to dictionary and save them to Firebase
          guard let senderDict = try? senderMessage.asDictionary() else {return}

          guard let recipientDict = try? recipientMessage.asDictionary() else {return}

          ChatViewModel.messagesId(senderId: senderId, recipientId: recipientId).setData(senderDict)
          ChatViewModel.messagesId(senderId: recipientId, recipientId: senderId).setData(recipientDict)

          onSuccess()
        } else { // error
          onError(error!.localizedDescription)
        }
      }
    }


  func sendPhotoMessage(ImageData: Data, recipientId: String, recipientProfile: String, recipientName: String,
                          onSuccess: @escaping() -> Void, onError: @escaping(_ error: String) -> Void) {

      // Getting the sender information from the current user
      guard let senderId = Auth.auth().currentUser?.uid else {return}
      guard let senderUsername = Auth.auth().currentUser?.displayName else {return}
      guard let senderProfile = Auth.auth().currentUser?.photoURL!.absoluteString else {return}

      //ID for chat message
      let messageId = ChatViewModel.conversation(sender: senderId, recipient: recipientId).document().documentID

      // metadata for the chat photo
      let storageChatRef = FirebaseViewModel.storagechatID(chatId: messageId)
      let metaData = StorageMetadata()
      metaData.contentType = "image/jpg"

      // Saving chat photo to Firebase storage
      FirebaseViewModel.saveChatPhoto(messageId: messageId, recipientId: recipientId, recipientProfile: recipientProfile, recipientName: recipientName, senderProfile: senderProfile, senderId: senderId, senderUsername: senderUsername, imageData: ImageData, metaData: metaData, storageChatRef: storageChatRef, onSuccess: onSuccess, onError: onError)
  }


  func getChats(userId: String, onSuccess: @escaping([ChatModel]) -> Void, onError: @escaping(_ error: String) -> Void, newChat: @escaping(ChatModel) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
      // napshot listener to get chats between current user and the given uid
      let listenerChat = ChatViewModel.conversation(sender: Auth.auth().currentUser!.uid, recipient: userId).order(by: "timestamp", descending: false).addSnapshotListener {
        (qs, err) in

        // error
        guard let snapshot = qs else {
          return
        }


        var chats = [ChatModel]()

        // Looping through the document changes
        snapshot.documentChanges.forEach {
          (diff) in

          // document is added
          if(diff.type == .added) {
            let dict = diff.document.data()

            // decoding to ChatModel from document data, and adding to chat array
            guard let decoded = try?
                    ChatModel.init(fromDictionary: dict) else {
              return
            }
            newChat(decoded)
            chats.append(decoded)
          }
          //  document is modified
          if(diff.type == .modified) {
            print("Modified")
          }
          //  document is removed
          if(diff.type == .removed) {
            print("Removed")
          }
        }

        onSuccess(chats)
      }

      listener(listenerChat)
    }

    func getMessages(onSuccess: @escaping([MessageModel]) -> Void, onError: @escaping(_ error: String) -> Void, newMessage: @escaping(MessageModel) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
      // snapshot listener to get messages between current user and all other users
      let listenerMessage = ChatViewModel.userMessages(userId: Auth.auth().currentUser!.uid).order(by: "timestamp", descending: true).addSnapshotListener {
        (qs, err) in

        // error
        guard let snapshot = qs else {
          return
        }


        var messages = [MessageModel]()

        // Looping through the document changes
        snapshot.documentChanges.forEach {
          (diff) in

          // document is added
          if(diff.type == .added) {
            let dict = diff.document.data()

            // Decoding to MessageModel from the document data, and adding it to messages array
            guard let decoded = try?
                    MessageModel.init(fromDictionary: dict) else {
              return
            }
            newMessage(decoded)
            messages.append(decoded)
          }
          // document is modified
          if(diff.type == .modified) {
            print("Modified")
          }
          // document is removed
          if(diff.type == .removed) {
            print("Removed")
          }
        }

        onSuccess(messages)
      }

      listener(listenerMessage)
    }
  }

