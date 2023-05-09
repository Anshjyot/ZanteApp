//
//  PostCardService.swift
//  Zante
//
//  Created by Anshjyot Singh on 25/03/2023.
//
import Foundation
import Firebase
import SwiftUI
import FirebaseStorage

class PostCardViewModel : ObservableObject {

  @Published var post: PostModel! // maybe nil at start
  @Published var isLiked = false

  func hasLikedPost() {
    isLiked = (post.likes["\(Auth.auth().currentUser!.uid)"] == true) ? true: false // has the user liked the post, if not false
  }

  func like() {
    post.likeCount += 1
    isLiked = true

    PostingViewModel.PostsUserId(userId: post.ownerId).collection("posts").document(post.postId) // inkrementere i alle disse:
      .updateData(["likeCount" : post.likeCount,"likes.\(Auth.auth().currentUser!.uid)": true])

    PostingViewModel.AllPosts.document(post.postId).updateData(
      ["likeCount" : post.likeCount,"likes.\(Auth.auth().currentUser!.uid)": true])

    PostingViewModel.timelineUserId(userId:
      post.ownerId).collection("timeline").document(post.postId)
      .updateData(["likeCount" : post.likeCount,
      "likes.\(Auth.auth().currentUser!.uid)": true])
  }

  func removelike() {
    post.likeCount -= 1
    isLiked = false

    PostingViewModel.PostsUserId(userId: post.ownerId).collection("posts").document(post.postId).updateData(["likeCount" :  post.likeCount,"likes.\(Auth.auth().currentUser!.uid)": false]) // decrement

    PostingViewModel.AllPosts.document(post.postId).updateData(["likeCount" : post.likeCount,"likes.\(Auth.auth().currentUser!.uid)": false])

    PostingViewModel.timelineUserId(userId: post.ownerId).collection("timeline").document(post.postId).updateData(["likeCount" : post.likeCount,"likes.\(Auth.auth().currentUser!.uid)": false])
  }

}


