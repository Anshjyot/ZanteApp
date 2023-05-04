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
  var mediaType: String?

  func toDictionary() throws -> [String: Any] {
          let encoder = JSONEncoder()
          let data = try encoder.encode(self)
          let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
          return json ?? [:]
      }
}



