//
//  PostModel.swift
//  Zante
//
//  Created by Anshjyot Singh on 23/03/2023.
//

import Foundation

struct PostModel: Encodable, Decodable {

  var caption: String
  var likes: [String: Bool]
  var location: String
  var ownerId: String
  var postId: String
  var username: String
  var profile: String
  var mediaUrl: String
  var date: Double
  var likeCount: Int
}
