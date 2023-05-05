//
//  Comment.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/04/2023.
//
import SwiftUI

struct Comment: View {
  @StateObject var commentViewModel = CommentViewModel()
  var post: PostModel?
  var postId: String?


    var body: some View {
      VStack(spacing: 10){
        ScrollView {
          if !commentViewModel.comments.isEmpty {
            ForEach(commentViewModel.comments) {
              (comment) in
              CommentCard(comment: comment).padding(.top)
            }
          }
        }
        CommentInput(post: post, postId: postId)
      }
      .navigationTitle("Comments")
      .onAppear{
        self.commentViewModel.postId = self.post == nil ? self.postId
        :self.post?.postId

        self.commentViewModel.loadComment()
      }
      .onDisappear {
        if self.commentViewModel.listener != nil {
          self.commentViewModel.listener.remove()
        }
      }


    }
}
