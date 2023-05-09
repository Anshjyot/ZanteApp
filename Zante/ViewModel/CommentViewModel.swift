//
//  CommentService.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/04/2023.
//
import Foundation
import Firebase

class CommentViewModel: ObservableObject {

  @Published var isLoading = false
  @Published var comments: [CommentModel] = []
  var postId: String!
  var listener: ListenerRegistration!
  var post: PostModel!

  static var commentsRef = AuthenticationViewModel.storeRoot.collection("comments")

  static func commentsId(postId: String) -> DocumentReference {
    return commentsRef.document(postId)
  }


  func postComment(comment: String, username: String, profile: String,ownerId: String, postId: String, onSuccess: @escaping() -> Void,
                   onError: @escaping(_ error: String) -> Void) {

    let comment = CommentModel(profile: profile, postId: postId, username: username, date: Date().timeIntervalSince1970, comment: comment, ownerId: ownerId)

    guard let dict = try? comment.asDictionary() else {
      return
    }

    CommentViewModel.commentsId(postId: postId).collection("comments").addDocument(data: dict) { // inserting comment ito firebase
      (err) in
      if let err = err {
        onError(err.localizedDescription)
        return
      }

      onSuccess()
    }
  }

  func getComments(postId: String, onSuccess: @escaping
                   ([CommentModel]) -> Void, onError: @escaping(_ error: String) -> Void, newComment: @escaping(CommentModel) -> Void,
                   listener: @escaping(_ listenerHandler: ListenerRegistration) -> Void) {

    // Listen for changes to comments under the specified post ID in Firestore
    let listenerPosts = CommentViewModel.commentsId(postId: postId).collection("comments")
      .order(by: "date", descending: false).addSnapshotListener {
        (snapshot, err) in

        guard let snapshot = snapshot else {return}

        var comments = [CommentModel] ()

        snapshot.documentChanges.forEach { // iterate through each document change
          (diff) in

          if (diff.type == .added) {
            let dict = diff.document.data()
            guard let decoded = try? CommentModel.init(fromDictionary: dict) else {
              return
            }

            // Pass the new comment to a closure for real-time UI updates
            newComment(decoded)
            comments.append(decoded)

          }
          if (diff.type == .modified) {
            print("Modified")
          }
          if (diff.type == .removed) {
            print("Removal")
          }
        }

        onSuccess(comments)
      }


    // Passing the listener to a closure, emoved later when it is no longer needed
    listener(listenerPosts)
  }

  func loadComment() {
    self.comments = [] // reset comments array
    self.isLoading = true
    self.getComments(postId: postId, // retrieve comments
                     onSuccess: {
      (comments) in

      if self.comments.isEmpty {
        self.comments = comments // set it to the retrieved comments
      }
    }, onError: {
      (err) in
    }, newComment: {
      (comment) in

      if !self.comments.isEmpty { // not empty
        self.comments.append(comment) // append new comment to it
      }
    }) {
      (listener) in // real time updates
      self.listener = listener
    }
  }


  func addComment(comment: String, onSuccess: @escaping() -> Void) {
    // Geting the current uid
    guard let currentUserId = Auth.auth().currentUser?.uid else {
      return
    }

    // Geting the current user's display name
    guard let username = Auth.auth().currentUser?.displayName else {
      return
    }

// photo url
    guard let profile = Auth.auth().currentUser?.photoURL?.absoluteString else {
      return
    }

    // Add the comment to post
    postComment(comment: comment, username: username, profile: profile, ownerId: currentUserId, postId: post.postId, onSuccess: {
      onSuccess()
    }) {
      (err) in
    }
  }
}
