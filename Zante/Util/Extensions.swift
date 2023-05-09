//
//  Extensions.swift
//  Zante
//
//  Created by Anshjyot Singh on 19/03/2023.
// https://stackoverflow.com/questions/67318879/swift-and-firebase-value-of-type-user-has-no-member-asdict

import Foundation
import FirebaseStorage

extension Encodable { // converts the Encodable object to a dictionary.
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

    else {
      throw NSError()
    }
    return dictionary

    }
  }

extension Decodable { // converts a dictionary to the Decodable object.
  init(fromDictionary: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: fromDictionary, options: .prettyPrinted)
                                                let decoder = JSONDecoder()
                                                self = try decoder.decode(Self.self, from: data)
  }
}


extension String { //  splits a string into an array of strings
  func splitString() -> [String] {
    var stringArray: [String] = []
    let trimmed = String(self.filter { !" \n\t\r".contains($0)})

    for (index, _) in trimmed.enumerated(){
      let prefixIndex = index+1
      let substringPrefix = String(trimmed.prefix(prefixIndex)).lowercased()
      stringArray.append(substringPrefix)
    }

    return stringArray
  }

  func removeWhiteSpace() -> String { //  removes white spaces from the string.
    return components(separatedBy: .whitespaces).joined()
  }

}


extension Date { // time difference between the current date and the date object as a string
  func timeAgo() -> String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]

    formatter.zeroFormattingBehavior = .dropAll
    formatter.maximumUnitCount = 1
    return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)

  }
}
