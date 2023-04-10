//
//  SignInView.swift
//  Zante
//
//  Created by Anshjyot Singh on 15/03/2023.
//

import SwiftUI

struct SignUpView: View {
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var username: String = ""
  @State private var profileImage: Image?
  @State private var pickedImage: Image?
  @State private var showingSheet = false
  @State private var showingImage = false
  @State private var imageData: Data = Data()
  @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
  @State private var error:String = ""
  @State private var showingAlert = false
  @State private var alertTitle: String = "Failed -,-"
  @State private var isLinkActive = false

  func loadImage() {
    guard let image = pickedImage else  {return}

    profileImage = image
  }

  func errorCheck() -> String? {
    if email.trimmingCharacters(in: .whitespaces).isEmpty ||
        password.trimmingCharacters(in: .whitespaces).isEmpty ||
        username.trimmingCharacters(in: .whitespaces).isEmpty ||
        imageData.isEmpty{
      return "Please fill in all boxes and provide an image for your profile"
    }

    return nil
  }

  func clear() {
    self.email = ""
    self.username = ""
    self.password = ""
    self.imageData = Data()
    self.profileImage = Image(systemName: "person.circle.fill")
  }

  func signUp() {
    if let error = errorCheck() {
      self.error = error
      self.showingAlert = true
      return
    }

    AuthService.signUp(username: username, email: email, password: password, imageData: imageData, onSuccess: {(user) in self.clear()}) {
      (errorMessage) in
      self.error = errorMessage
      self.showingAlert = true
      self.clear()
      return
    }
  }



    var body: some View {
      ScrollView {
        VStack(spacing: 20){
          Image(systemName: "music.note").font(.system(size: 60, weight: .black, design: .default))

          VStack(alignment: .leading){
            Text("Hi there").font(.system(size: 34, weight: .heavy))
            Text("Sign Up").font(.system(size: 17, weight: .medium))
          }

          VStack{
            Group {
              if profileImage != nil { profileImage!.resizable()
                  .clipShape(Circle())
                  .frame(width: 150, height: 150)
                  .padding(.top, 20)
                  .onTapGesture {
                    self.showingSheet = true

                  }

              } else {
                Image(systemName: "person.circle.fill")
                  .resizable()
                  .clipShape(Circle())
                  .frame(width: 100, height: 100)
                  .padding(.top, 20)
                  .onTapGesture {
                    self.showingSheet = true
                  }
              }
            }
          }

          Group {
            FormField(value: $username, icon: "person.fill", placeholder: "Username")

            FormField(value: $email, icon: "envelope.fill", placeholder: "E-mail")

            FormField(value: $password, icon: "lock.fill", placeholder: "Password", isSecure: true)
          }

          NavigationLink(destination: LogInView(), isActive: $isLinkActive) {
            EmptyView()
          Button(action: { signUp()
            self.isLinkActive = true
          }){
            Text("Sign Up").font(.title)
              .modifier(ButtonModifiers())
          }
            }.alert(isPresented: $showingAlert) {
              Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
            }


        }.padding()
      }.sheet(isPresented: $showingImage, onDismiss: loadImage) {
        ProfileImage(image: self.$pickedImage, showImage: self.$showingImage, imageData: self.$imageData)


      }.actionSheet(isPresented: $showingSheet) {
        ActionSheet(title: Text(""), buttons:[ .default(Text("Choose Photo")){
          self.sourceType = .photoLibrary
          self.showingImage = true
        },

        .default(Text("Take a Photo")){
          self.sourceType = .camera
          self.showingImage = true
        }, .cancel()
         ])
      }


    }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView()
  }
}


