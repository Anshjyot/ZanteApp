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

class PostingViewModel: ObservableObject {

  static var Posts = AuthenticationViewModel.storeRoot.collection("posts")
  static var AllPosts = AuthenticationViewModel.storeRoot.collection("allPosts")
  static var Timeline = AuthenticationViewModel.storeRoot.collection("timeline")

  static func PostsUserId(userId: String) -> DocumentReference {
    return Posts.document(userId)
  }

  static func timelineUserId(userId: String) -> DocumentReference {
    return Timeline.document(userId)
  }

  static func uploadPost(caption: String, imageData: Data, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
    guard let userId = Auth.auth().currentUser?.uid else {
      return // cant retrive data
    }

    let postId = PostingViewModel.PostsUserId(userId: userId).collection("posts").document().documentID // new postID
    let storagePostRef = FirebaseViewModel.storagePostID(postId: postId)
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"

    FirebaseViewModel.savePostPhoto(userId: userId, caption: caption, postId: postId, imageData: imageData, metadata: metaData, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
  }

  static func loadPost(postId: String, onSuccess: @escaping(_ post: PostModel) -> Void) {
    PostingViewModel.AllPosts.document(postId).getDocument { // loads a post with postid
      (snapshot, err) in

      guard let snap = snapshot else { // fetching error
        print("Error")
        return
      }

      let dict = snap.data() // post data from doc snapshot
      guard let decoded = try? PostModel.init(fromDictionary: dict!) else { // decoding post data into PostModel object
        return
      }
      onSuccess(decoded)
    }
  }



  static func loadUserPosts(userId: String, onSuccess: @escaping(_ posts: [PostModel]) -> Void) {
    PostingViewModel.PostsUserId(userId: userId).collection("posts").getDocuments{(snapshot, error) in
      guard let snap = snapshot else {
        print("Error")
        return
      }

      var posts = [PostModel]()

      for doc in snap.documents { // decoder all post data to postModel object
        let dict = doc.data()
        guard let decoder = try? PostModel.init(fromDictionary: dict)
        else {
          return
        }

        posts.append(decoder) //posts array
      }

      onSuccess(posts)
    }
  }


  static func loadAllUsersPosts(onSuccess: @escaping(_ posts: [PostModel]) -> Void) {
        var allPosts = [PostModel]()

        // fetching all users
        AuthenticationViewModel.storeRoot.collection("users").getDocuments { (usersSnapshot, error) in
            guard let usersSnapshot = usersSnapshot else { // error handling
                print("Error fetching users: \(error?.localizedDescription ?? "")")
                return
            }

            // fetching their posts
            for userDoc in usersSnapshot.documents {
                let userId = userDoc.documentID
                PostsUserId(userId: userId).collection("posts").getDocuments { (postsSnapshot, error) in
                    guard let postsSnapshot = postsSnapshot else {
                        print("Error fetching posts for user \(userId): \(error?.localizedDescription ?? "")")
                        return
                    }

                    // decoding each post it to a PostModel object and add it to the list of all posts
                    for postDoc in postsSnapshot.documents {
                        let dict = postDoc.data()
                        guard let post = try? PostModel(fromDictionary: dict) else {
                            print("Error decoding post: \(dict)")
                            continue
                        }

                        allPosts.append(post) // add to listen
                    }

                    onSuccess(allPosts)
                }
            }
        }
    }

  static func uploadAudioPost(caption: String, audioData: Data, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
      guard let userId = Auth.auth().currentUser?.uid else { // get currently logged in, uid. 
        return
      }

      let postId = PostingViewModel.PostsUserId(userId: userId).collection("posts").document().documentID
      let storagePostRef = FirebaseViewModel.storagePostID(postId: postId)
      let metaData = StorageMetadata()
      metaData.contentType = "audio/mpeg"

    FirebaseViewModel.saveAudioPost(userId: userId, caption: caption, postId: postId, audioData: audioData, metadata: metaData, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
  }






}


