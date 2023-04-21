//
//  UserProfile.swift
//  Zante
//
//  Created by Anshjyot Singh on 08/04/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseStorage

struct UserProfile: View {

  @State private var value: String = ""
  @State var users: [User] = []
  @State var isLoading = false

  func searchUsers(){
    isLoading = true

    SearchService.searchUser(input: value) {
      (users) in

      self.isLoading = false
      self.users = users
    }
  }
    var body: some View {
      ScrollView {
        VStack(alignment: .leading){
          SearchBar(value: $value).padding()
            .onChange(of: value, perform: {
              new in

              searchUsers()
            })

          if !isLoading {
            ForEach(users, id:\.uid) {
              user in

              NavigationLink(destination: UsersProfileView(user: user)) {
                HStack{
                  WebImage(url: URL(string: user.profileImageURL)!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60, alignment: .trailing)
                    .padding()

                  Text(user.userName).font(.subheadline).bold()
                }
              }
            }
          }
        }
      }.navigationTitle("User Search")
    }
}

