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

  func loadImage() {
    guard let image = pickedImage else  {return}

    profileImage = image
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


            Button(action: {}){
              Text("Sign Up").font(.title)
                .modifier(ButtonModifiers())
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


