//
//  ChatModel.swift
//  Zante
//
//  Created by Anshjyot Singh on 10/04/2023.
//

import Foundation
import Firebase

struct ChatModel: Encodable, Decodable, Hashable {
  var messageId: String
  var textMessage: String
  var profile: String
  var photoUrl: String
  var sender: String
  var username: String
  var timestamp: Double
  var isCurrentUser: Bool {
    return Auth.auth().currentUser!.uid == sender
  }

  var isPhoto: Bool





}

