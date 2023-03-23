//
//   UserModel.swift
//  Zante
//
//  Created by Anshjyot Singh on 19/03/2023.
//

import Foundation

struct User: Encodable, Decodable{
  var uid: String
  var email: String
  var profileImageURL: String
  var userName: String
  var seachName: [String]
  var bio: String
}
