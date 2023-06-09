//
//  CommentInput.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/04/2023.
//
import SwiftUI
import SDWebImageSwiftUI


struct CommentInput: View {
  @EnvironmentObject var session: SessionViewModel
  @ObservedObject var commentService = CommentViewModel()
  @State private var text: String = ""

  init(post: PostModel?, postId: String?) {
    if post != nil {
      commentService.post = post
    } else {

      handleInput(postId: postId!)

    }
  }

  func handleInput(postId: String) {
    PostingViewModel.loadPost(postId: postId) {
      (post) in
      self.commentService.post = post
    }
  }

    
    func sendComment() {
        if !text.isEmpty {
            guard let username = session.session?.userName,
                  let profile = session.session?.profileImageURL else {
                // handle missing session values
                return
            }
          //default value if nil
            let ownerId = commentService.post?.ownerId ?? ""
            let postId = commentService.post?.postId ?? ""
            commentService.postComment(comment: text, username: username, profile: profile, ownerId: ownerId, postId: postId) {
                self.text = ""
            } onError: { error in
                // handle error
            }
        }
    }



    var body: some View {
      HStack {
        WebImage(url: URL(string: session.session!.profileImageURL)!)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .scaledToFit()
          .clipShape(Circle())
          .frame(width: 50, height: 50, alignment: .center)
          .shadow(color: .gray, radius: 3)
          .padding(.leading)

        HStack {
          TextEditor(text: $text)
            .frame(height: 50)
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 8, style: .circular).stroke(Color.black, lineWidth: 2))

          Button(action: sendComment) {
            Image(systemName: "paperplane").imageScale(.large).padding(.trailing)
          }
        }
      }
    }
}
