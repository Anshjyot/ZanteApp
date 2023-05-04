//
//  MessageModel.swift
//  Zante
//
//  Created by Anshjyot Singh on 10/04/2023.
//

import Foundation


struct MessageModel: Encodable, Decodable, Identifiable {
  var id = UUID()
  var lastMessage: String
  var username: String
  var isPhoto: Bool
  var timestamp: Double
  var userId: String
  var profile: String




}

