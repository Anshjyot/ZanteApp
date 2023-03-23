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

  @State private var error:String = ""
  @State private var showingAlert = false
  @State private var alertTitle: String = "Failed -,-"


  func errorCheck() -> String? {
    if email.trimmingCharacters(in: .whitespaces).isEmpty ||
        password.trimmingCharacters(in: .whitespaces).isEmpty
    {
      return "Please fill in all boxes"
    }

    return nil
  }

  func clear() {
    self.email = ""
    self.password = ""
  }

  func logIn() {
    if let error = errorCheck()  {
      self.error = error
      self.showingAlert = true
      self.clear()
      return
    }

    AuthService.logIn(email: email, password: password, onSuccess: {
      (user) in
      self.clear()

    }){
      (errorMessage) in
      print("Error \(errorMessage)")
      self.error = errorMessage
      self.showingAlert = true
      return
    }
  }



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

            Button(action: logIn){
              Text("Log In").font(.title)
                .modifier(ButtonModifiers())
            }.alert(isPresented: $showingAlert) {
              Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
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


