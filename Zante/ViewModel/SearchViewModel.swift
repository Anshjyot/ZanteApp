//
//  SearchService.swift
//  Zante
//
//  Created by Anshjyot Singh on 08/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

class SearchViewModel{
  static func searchUser(input: String, onSuccess: @escaping (_ user: [User]) -> Void) {

    AuthenticationViewModel.storeRoot.collection("users").whereField("searchName", arrayContains: input.lowercased().removeWhiteSpace()).getDocuments {
      (querySnapshot, err) in
      guard let snap = querySnapshot else {
        print("error")
        return
      }
      var users = [User]()
      for document in snap.documents { // retrieves the data as a dictionary
        let dict = document.data()

        guard let decoded = try? User.init(fromDictionary: dict) else {
          return
        }

        if decoded.uid != Auth.auth().currentUser!.uid { //Removing current user from the search results
          users.append(decoded)
        }
        onSuccess(users)
      }

    }
    }
}

