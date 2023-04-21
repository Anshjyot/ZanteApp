import SwiftUI

enum MediaType {
    case image
    case audio
}


struct Post: View {
    @State private var postImage: Image?
    @State private var pickedImage: Image?
    @State private var showingSheet = false
    @State private var showingImage = false
    @State private var imageData: Data = Data()
    @State private var audioData: Data?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var error: String = ""
    @State private var showingAlert = false
    @State private var alertTitle: String = "Failed -,-"
    @State private var text = ""
    @State private var selectedMediaType: MediaType = .image

    func loadImage() {
        guard let image = pickedImage else { return }
        postImage = image
    }

    func uploadPost() {
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            self.clear()
            return
        }

        PostService.uploadPost(caption: text, imageData: imageData, audioData: audioData, onSuccess: {
            self.clear()
        }) { (errorMessage) in
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
            (imageData.isEmpty && audioData == nil) {
            return "Please add a caption and provide an image or an audio file for your post"
        }
        return nil
    }

  var body: some View {
    VStack {
      Text("Upload a post").font(.largeTitle)

      VStack {
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
        if selectedMediaType == .image {
          ProfileImage(image: self.$pickedImage, showImage: self.$showingImage, imageData: self.$imageData)
        } else if selectedMediaType == .audio {
          AudioPicker(showAudioPicker: self.$showingImage, audioData: self.$audioData)
        }
      }
      .actionSheet(isPresented: $showingSheet) {
        ActionSheet(title: Text(""), buttons: [
          .default(Text("Choose Photo")) {
            self.selectedMediaType = .image
            self.sourceType = .photoLibrary
            self.showingImage = true
          },
          .default(Text("Take a Photo")) {
            self.selectedMediaType = .image
            self.sourceType = .camera
            self.showingImage = true
          },
          .default(Text("Select Audio")) {
            self.selectedMediaType = .audio
            self.showingImage = true
          },
          .cancel()
        ])
      }
  }

    }

