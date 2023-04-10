//
//  Add.swift
//  Zante
//
//  Created by Anshjyot Singh on 23/03/2023.
//

import SwiftUI

struct Post: View {
  @State private var postImage: Image?
  @State private var pickedImage: Image?
  @State private var showingSheet = false
  @State private var showingImage = false
  @State private var imageData: Data = Data()
  @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
  @State private var error:String = ""
  @State private var showingAlert = false
  @State private var alertTitle: String = "Failed -,-"
  @State private var text = ""


  func loadImage() {
    guard let image = pickedImage else  {return}

    postImage = image
  }

  func uploadPost() {
    if let error = errorCheck() {
      self.error = error
      self.showingAlert = true
      self.clear()
      return
    }

    PostService.uploadPost(caption: text, imageData: imageData, onSuccess: {
      self.clear()
    }) {
      (errorMessage) in
      self.error = errorMessage
      self.showingAlert = true
      return

    }


  }

  func clear() {
    self.text = ""
    self.imageData = Data()
    self.postImage = Image(systemName: "photo.fill")
  }


  func errorCheck() -> String? {
    if text.trimmingCharacters(in: .whitespaces).isEmpty ||

        imageData.isEmpty{
      return "Please add a caption and provide an image for your post"
    }

    return nil
  }




    var body: some View {
      VStack{
        Text("Upload a post").font(.largeTitle)

        VStack{
          if postImage != nil {
            postImage!.resizable()
              .frame(width: 300, height: 200)
              .onTapGesture {
                self.showingSheet = true
              }
          } else {
            Image(systemName: "photo.fill").resizable()
              .frame(width: 300, height: 200)
              .onTapGesture {
                self.showingSheet = true
              }
          }
        }

        TextEditor(text: $text)
          .frame(height: 200)
          .padding(4)
          .background(RoundedRectangle(cornerRadius: 0).stroke(Color.black))
          .padding(.horizontal)


        Button(action: uploadPost) {
          Text("Upload Post").font(.title).modifier(ButtonModifiers())
        }.alert(isPresented: $showingAlert) {
          Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
        }
      }.padding()
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
