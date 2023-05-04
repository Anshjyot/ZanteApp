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

class PostService: ObservableObject {

  static var Posts = AuthService.storeRoot.collection("posts")
  static var AllPosts = AuthService.storeRoot.collection("allPosts")
  static var Timeline = AuthService.storeRoot.collection("timeline")

  static func PostsUserId(userId: String) -> DocumentReference {
    return Posts.document(userId)
  }

  static func timelineUserId(userId: String) -> DocumentReference {
    return Timeline.document(userId)
  }

  static func uploadPost(caption: String, imageData: Data, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }

    let postId = PostService.PostsUserId(userId: userId).collection("posts").document().documentID
    let storagePostRef = StorageService.storagePostID(postId: postId)
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"

    StorageService.savePostPhoto(userId: userId, caption: caption, postId: postId, imageData: imageData, metadata: metaData, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
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


  static func loadAllUsersPosts(onSuccess: @escaping(_ posts: [PostModel]) -> Void) {
        var allPosts = [PostModel]()

        // First, fetch all users
        AuthService.storeRoot.collection("users").getDocuments { (usersSnapshot, error) in
            guard let usersSnapshot = usersSnapshot else {
                print("Error fetching users: \(error?.localizedDescription ?? "")")
                return
            }

            // Then, for each user, fetch their posts
            for userDoc in usersSnapshot.documents {
                let userId = userDoc.documentID
                PostsUserId(userId: userId).collection("posts").getDocuments { (postsSnapshot, error) in
                    guard let postsSnapshot = postsSnapshot else {
                        print("Error fetching posts for user \(userId): \(error?.localizedDescription ?? "")")
                        return
                    }

                    // Finally, for each post, decode it to a PostModel object and add it to the list of all posts
                    for postDoc in postsSnapshot.documents {
                        let dict = postDoc.data()
                        guard let post = try? PostModel(fromDictionary: dict) else {
                            print("Error decoding post: \(dict)")
                            continue
                        }

                        allPosts.append(post)
                    }

                    onSuccess(allPosts)
                }
            }
        }
    }




  /*
  static func loadAllPosts(onSuccess: @escaping(_ posts: [PostModel]) -> Void) {
      AllPosts.getDocuments { (snapshot, error) in
          guard let snapshot = snapshot else {
              print("Error fetching all posts: \(error?.localizedDescription ?? "")")
              return
          }

          var allPosts = [PostModel]()

          for doc in snapshot.documents {
              let dict = doc.data()
              guard let post = try? PostModel(fromDictionary: dict) else {
                  print("Error decoding post: \(dict)")
                  continue
              }
              allPosts.append(post)
          }

          print("Fetched all posts: \(allPosts.count)") // Add this line
          onSuccess(allPosts)
      }
  }
   */



  /*
  static func loadAllUsersPosts(onSuccess: @escaping(_ posts: [PostModel]) -> Void) {
      Firestore.firestore().collectionGroup("posts").getDocuments { (snapshot, error) in
          guard let snap = snapshot else {
              print("Error fetching all users' posts")
              return
          }

          var allPosts = [PostModel]()

          for doc in snap.documents {
              let dict = doc.data()
              guard let decoder = try? PostModel.init(fromDictionary: dict) else {
                  return
              }
              allPosts.append(decoder)
          }

          print("Fetched all users' posts: \(allPosts.count)") // Add this line
          onSuccess(allPosts)
      }
  }
   */








  /*
  static func loadAllUsersPosts(onSuccess: @escaping(_ posts: [PostModel]) -> Void) {
       var allPosts = [PostModel]()

       // First, fetch all users
       AuthService.storeRoot.collection("users").getDocuments { (usersSnapshot, error) in
           guard let usersSnapshot = usersSnapshot else {
               print("Error fetching users: \(error?.localizedDescription ?? "")")
               return
           }

           // Then, for each user, fetch their posts
           for userDoc in usersSnapshot.documents {
               let userId = userDoc.documentID
               PostsUserId(userId: userId).collection("posts").getDocuments { (postsSnapshot, error) in
                   guard let postsSnapshot = postsSnapshot else {
                       print("Error fetching posts for user \(userId): \(error?.localizedDescription ?? "")")
                       return
                   }

                   // Finally, for each post, decode it to a PostModel object and add it to the list of all posts
                   for postDoc in postsSnapshot.documents {
                       let dict = postDoc.data()
                       guard let post = try? PostModel(fromDictionary: dict) else {
                           print("Error decoding post: \(dict)")
                           continue
                       }

                       allPosts.append(post)
                   }

                   onSuccess(allPosts)
               }
           }
       }
   }

   */






}


