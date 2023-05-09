//
//  FollowService.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/04/2023.
//

import Foundation
import Firebase
import FirebaseStorage

class FollowViewModel: ObservableObject {

  func updateFollowCount(userId: String, followingCount: @escaping (_ followingCount: Int) -> Void, followersCount: @escaping (_ followingCount: Int) -> Void) {

    ProfileViewModel.followingCollection(userId: userId).getDocuments { // fetches data and update
      (snap, error) in
      if let doc = snap?.documents {
        followingCount(doc.count)
      }
    }

    ProfileViewModel.followersCollection(userId: userId).getDocuments {
      (snap, error) in
      if let doc = snap?.documents {
        followersCount(doc.count)
      }
    }

  }

  func manageFollow(userId: String, followCheck: Bool, followingCount: @escaping (_ followingCount: Int) -> Void, followersCount: @escaping (_ followersCount: Int) -> Void) {

    if !followCheck {
      follow(userId: userId, followingCount: followingCount, followersCount: followersCount) // if not following, then follow
    } else {
      unfollow(userId: userId, followingCount: followingCount, followersCount: followersCount) // unfollow, if already following
    }

  }

  func follow(userId: String, followingCount: @escaping (_ followingCount: Int) -> Void, followersCount: @escaping (_ followersCount: Int) -> Void) {

    ProfileViewModel.followingId(userId: userId).setData([:]) {  // empty dictionary
      (err) in
      if err == nil {
        self.updateFollowCount(userId: userId, followingCount: followingCount, followersCount: followersCount)
      }
    }

    ProfileViewModel.followersId(userId: userId).setData([:]) {
      (err) in
      if err == nil {
        self.updateFollowCount(userId: userId, followingCount: followingCount, followersCount: followersCount)
      }
    }


  }


  func unfollow(userId: String, followingCount: @escaping (_ followingCount: Int) -> Void, followersCount: @escaping (_ followersCount: Int) -> Void) {

    ProfileViewModel.followingId(userId: userId).getDocument {
      (document, err) in

      if let doc = document, doc.exists {
        doc.reference.delete()

        self.updateFollowCount(userId: userId, followingCount: followingCount, followersCount: followersCount)
      }
    }

    ProfileViewModel.followersId(userId: userId).getDocument {
      (document, err) in

      if let doc = document, doc.exists {
        doc.reference.delete()

        self.updateFollowCount(userId: userId, followingCount: followingCount, followersCount: followersCount)
      }
    }



  }


}

