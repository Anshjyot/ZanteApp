//
//  SignInView.swift
//  Zante
//
//  Created by Anshjyot Singh on 15/03/2023.
//

import SwiftUI

struct LogInView: View {
  @State private var email: String = ""
  @State private var password: String = ""

    var body: some View {
      NavigationView {

        VStack(spacing: 20){
          Image(systemName: "music.note").font(.system(size: 60, weight: .black, design: .default))

          VStack(alignment: .leading){
            Text("Welcome Back").font(.system(size: 34, weight: .heavy))
            Text("Log In to Continue").font(.system(size: 17, weight: .medium))
          }

            FormField(value: $email, icon: "envelope.fill", placeholder: "E-mail")

            FormField(value: $password, icon: "lock.fill", placeholder: "Password", isSecure: true)

            Button(action: {}){
              Text("Log In").font(.title)
                .modifier(ButtonModifiers())
            }

          HStack{
            Text("New?")
            NavigationLink(destination: SignUpView()){
              Text("Create an Account.").font(.system(size: 18, weight: .semibold))
            }
          }

        }.padding()
      }
    }
}

struct LogInView_Previews: PreviewProvider {
  static var previews: some View {
    LogInView()
  }
}


