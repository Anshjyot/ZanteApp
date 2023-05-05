//
//  Post.swift
//  Zante
//
//  Created by Anshjyot Singh on 23/03/2023.
//
import SwiftUI

struct PostingView: View {
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
  @State private var audioURL: URL?
  @State private var isAudioFile: Bool = false
  @State private var mediaType: String = "image"
  @State private var showAudioPicker = false
  @State private var audioData: Data?
  @State private var selectedAudioFileName: String?
  @State private var showImagePicker = false



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

    if mediaType == "audio" {
      PostingViewModel.uploadAudioPost(caption: text, audioData: audioData!, onSuccess: {
        self.clear()
      }) { (errorMessage) in
        self.error = errorMessage
        self.showingAlert = true
        return
      }
    } else {
      PostingViewModel.uploadPost(caption: text, imageData: imageData, onSuccess: {
        self.clear()
      }) { (errorMessage) in
        self.error = errorMessage
        self.showingAlert = true
        return
      }
    }
  }

  func clear() {
    self.text = ""
    self.imageData = Data()
    self.postImage = Image(systemName: "photo.fill")
    self.selectedAudioFileName = nil

  }


  func errorCheck() -> String? {
      if text.trimmingCharacters(in: .whitespaces).isEmpty {
          return "Please add a caption for your post"
      }

      if mediaType == "image" && imageData.isEmpty {
          return "Please provide an image for your post"
      }

      if mediaType == "audio" && (audioData == nil || selectedAudioFileName == nil) {
          return "Please provide an audio file for your post"
      }

      return nil
  }




  var body: some View {

    if showAudioPicker {
      if mediaType == "audio" {
        AudioPicker(showAudioPicker: $showAudioPicker, audioData: $audioData, selectedAudioFileName: $selectedAudioFileName)
      } else {
        ProfileImage(image: self.$pickedImage, showImage: self.$showingImage, imageData: self.$imageData)
      }
    }

    VStack{
      Text("Upload a post").font(.largeTitle)
        .foregroundColor(.blue)

      VStack {
        if postImage != nil {
          postImage!.resizable()
            .frame(width: 300, height: 200)
            .onTapGesture {
              self.showingSheet = true
            }
        } else if selectedAudioFileName != nil {
          Text(selectedAudioFileName!)
            .font(.title)
            .padding()
            .onTapGesture {
              self.showingSheet = true
            }
        } else {
          Image(systemName: "rectangle.and.paperclip").resizable()
            .frame(width: 300, height: 200)
            .onTapGesture {
              self.showingSheet = true
            }
        }
      }


      TextView(text: $text)
        .frame(height: 100)
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 0).stroke(Color.black))
        .padding(.horizontal)


      Button(action: uploadPost) {
        Text("Upload Post")
          .font(.title)
          .foregroundColor(.white)
          .padding(.horizontal, 120)
          .padding(.vertical, 5)
      }
      .background(Color.blue)
      .cornerRadius(10)
      .alert(isPresented: $showingAlert) {
        Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
      }
    }
    .padding()
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ProfileImage(image: self.$pickedImage, showImage: self.$showImagePicker, imageData: self.$imageData)
            }
            .sheet(isPresented: $showAudioPicker, onDismiss: nil) {
                AudioPicker(showAudioPicker: self.$showAudioPicker, audioData: self.$audioData, selectedAudioFileName: self.$selectedAudioFileName)
            }
            .actionSheet(isPresented: $showingSheet) {
                ActionSheet(title: Text("Select Media Type"), buttons:[
                    .default(Text("Choose Photo")) {
                        self.sourceType = .photoLibrary
                        self.showImagePicker = true
                        self.mediaType = "image"
                    },
                    .default(Text("Take a Photo")) {
                        self.sourceType = .camera
                        self.showImagePicker = true
                        self.mediaType = "image"
                    },
                    .default(Text("Upload Audio")) {
                        self.showingSheet = false
                        self.showAudioPicker = true
                        self.mediaType = "audio"
                    },
                    .cancel()
                ])
            }
        }
    }
