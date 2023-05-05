//
//  EditProfile.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/04/2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

struct EditProfile: View {
  @EnvironmentObject var session: SessionViewModel
  @State private var username: String = ""
  @State private var profileImage: Image?
  @State private var pickedImage: Image?
  @State private var showingSheet = false
  @State private var showingImage = false
  @State private var imageData: Data = Data()
  @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
  @State private var error: String = ""
  @State private var showingAlert = false
  @State private var alertTitle: String = "Failed -,-"
  @State private var bio: String = ""



  init(session: User?) {
    _bio = State(initialValue: session?.bio ?? "")
    _username = State(initialValue: session?.userName ?? "")
  }

  func loadImage() {
    guard let inputImage = pickedImage else  {return }

    profileImage = inputImage
  }

  func errorCheck() -> String? {
    if username.trimmingCharacters(in: .whitespaces).isEmpty ||
        bio.trimmingCharacters(in: .whitespaces).isEmpty ||
        imageData.isEmpty{
      return "Please fill in all boxes and provide an image for your profile"
    }

    return nil
  }

  func clear() {
    self.bio = ""
    self.username = ""
    self.imageData = Data()
    self.profileImage = Image(systemName: "person.circle.fill")
  }

  func edit() {
    if let error = errorCheck() {
      self.error = error
      self.showingAlert = true
      self.clear()
      return
    }

    guard let userId = Auth.auth().currentUser?.uid else {return}

    let storageProfileUserId = FirebaseViewModel.storageProfileID(userId: userId)

    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"

    FirebaseViewModel.editProfile(userId: userId, username: username, bio: bio, imageData: imageData, metaData: metaData, storageProfileImageRef: storageProfileUserId, onError: {
      (errorMessage) in

      self.error = errorMessage
      self.showingAlert = true
      return
    })

    self.clear()

  }


    var body: some View {
      ScrollView {
        VStack(spacing: 20) {
          Text("Edit Profile").font(.largeTitle)
          VStack {
            Group {
              if profileImage != nil { profileImage!.resizable()
                  .clipShape(Circle())
                  .frame(width: 200, height: 200)
                  .padding(.top, 20)
                  .onTapGesture {
                    self.showingSheet = true

                  }

              } else {
                WebImage(url: URL(string: session.session!.profileImageURL)!)
                  .resizable()
                  .clipShape(Circle())
                  .frame(width: 200, height: 200)
                  .padding(.top, 20)
                  .onTapGesture {
                    self.showingSheet = true
                  }
              }
            }
          }

          FormField(value: $username, icon: "person.fill", placeholder: "Username")
          FormField(value: $bio, icon: "book.fill", placeholder: "Bio")
          Button(action: edit) {
            Text("Edit").font(.title).modifier(ButtonModifiers())
          }.padding()
          .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
          }

          Text("Changes will appear when you log in again")

        }
      }.navigationTitle(session.session!.userName)
        .sheet(isPresented: $showingImage, onDismiss: loadImage) {
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



