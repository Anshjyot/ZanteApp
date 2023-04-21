//
//  PostService.swift
//  Zante
//
//  Created by Anshjyot Singh on 23/03/2023.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class PostService {

  static var Posts = AuthService.storeRoot.collection("posts")
  static var AllPosts = AuthService.storeRoot.collection("allPosts")
  static var Timeline = AuthService.storeRoot.collection("timeline")

  static func PostsUserId(userId: String) -> DocumentReference {
    return Posts.document(userId)
  }

  static func timelineUserId(userId: String) -> DocumentReference {
    return Timeline.document(userId)
  }

  /*static func uploadPost(caption: String, imageData: Data, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }

    let postId = PostService.PostsUserId(userId: userId).collection("posts").document().documentID
    let storagePostRef = StorageService.storagePostID(postId: postId)
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"

    StorageService.savePostPhoto(userId: userId, caption: caption, postId: postId, imageData: imageData, metadata: metaData, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
  }
   */

  static func uploadPost(caption: String, imageData: Data?, audioData: Data?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
      guard let userId = Auth.auth().currentUser?.uid else {
          return
      }

      let postId = PostService.PostsUserId(userId: userId).collection("posts").document().documentID

      if let imageData = imageData {
          let storagePostRef = StorageService.storagePostID(postId: postId, isImage: true) // Update this line
          let metaData = StorageMetadata()
          metaData.contentType = "image/jpg"

          StorageService.savePostPhoto(userId: userId, caption: caption, postId: postId, imageData: imageData, metadata: metaData, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
      }

      if let audioData = audioData {
          let storagePostRef = StorageService.storagePostID(postId: postId, isImage: false) // Update this line
          let metaData = StorageMetadata()
          metaData.contentType = "audio/mp3"

          StorageService.savePostAudio(userId: userId, caption: caption, postId: postId, audioData: audioData, metadata: metaData, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
      }
  }


  static func loadPost(postId: String, onSuccess: @escaping(_ post: PostModel) -> Void) {
    PostService.AllPosts.document(postId).getDocument {
      (snapshot, err) in

      guard let snap = snapshot else {
        print("Error")
        return
      }

      let dict = snap.data()
      guard let decoded = try? PostModel.init(fromDictionary: dict!) else {
        return
      }
      onSuccess(decoded)
    }
  }

  static func loadUserPosts(userId: String, onSuccess: @escaping(_ posts: [PostModel]) -> Void) {
    PostService.PostsUserId(userId: userId).collection("posts").getDocuments{(snapshot, error) in
      guard let snap = snapshot else {
        print("Error")
        return
      }

      var posts = [PostModel]()

      for doc in snap.documents {
        let dict = doc.data()
        guard let decoder = try? PostModel.init(fromDictionary: dict)
        else {
          return
        }

        posts.append(decoder)
      }

      onSuccess(posts)
    }
  }

}
