//
//  ProfileService.swift
//  Zante
//
//  Created by Anshjyot Singh on 25/03/2023.
//
import Foundation
import Firebase
import FirebaseStorage

class ProfileViewModel : ObservableObject {
  @Published var posts: [PostModel] = []
  @Published var following = 0
  @Published var followers = 0
  @Published var isLoading = false
  @Published var followCheck = false
  @Published var allPosts: [PostModel] = []

  static var following = AuthenticationViewModel.storeRoot.collection("following")
  static var followers = AuthenticationViewModel.storeRoot.collection("followers")

  static func followingCollection(userId: String) -> CollectionReference{
    return following.document(userId).collection("following")
  }

  static func followersCollection(userId: String) -> CollectionReference{
    return followers.document(userId).collection("followers")
  }

  static func followingId(userId: String) -> DocumentReference {
    return following.document(Auth.auth().currentUser!.uid).collection("following").document(userId)
  }

  static func followersId(userId: String) -> DocumentReference {
    return followers.document(userId).collection("followers").document(Auth.auth().currentUser!.uid)
  }

  func followState(userid: String) {
    ProfileViewModel.followingId(userId: userid).getDocument {
      (document, error) in

      if let doc = document, doc.exists {
        self.followCheck = true
      } else {
        self.followCheck = false
      }
    }
  }

  func loadUserPosts(userId : String) {
    PostingViewModel.loadUserPosts(userId: userId) {
      (posts) in

      self.posts = posts
    }

    follows(userId: userId)
    followers(userId: userId)
  }


  func loadAllUsersPosts() {
    PostingViewModel.loadAllUsersPosts { (posts) in
           self.posts = posts
       }
   }


  func follows(userId: String) {
    ProfileViewModel.followingCollection(userId: userId).getDocuments {
      (querysnapshot, err) in

      if let doc = querysnapshot?.documents {
        self.following = doc.count
      }
    }
  }

  func followers(userId: String) {
    ProfileViewModel.followersCollection(userId: userId).getDocuments {
      (querysnapshot, err) in

      if let doc = querysnapshot?.documents {
        self.followers = doc.count
      }
    }
  }
}