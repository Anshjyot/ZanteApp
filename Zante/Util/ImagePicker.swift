//
//  ProfileImage.swift
//  Zante
//
//  Created by Anshjyot Singh on 15/03/2023.
// https://stackoverflow.com/questions/56515871/how-to-open-the-imagepicker-in-swiftui
// https://www.appcoda.com/swiftui-camera-photo-library/

import Foundation
import FirebaseStorage
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: Image? //optional fordi før man vælger et image, så vil der ikke være et
  @Binding var showImage: Bool
  @Binding var imageData: Data


  func makeCoordinator() -> ImagePicker.Coordinator {
    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    picker.allowsEditing = true
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

  }

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker

    init(_ parent: ImagePicker) {
      self.parent = parent
    }

    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      let uiImage = info[.editedImage] as! UIImage
      parent.image = Image(uiImage: uiImage)

      if let data = uiImage.jpegData(compressionQuality: 0.5) {
        parent.imageData = data
      }

      parent.showImage = false
    }
  }
}
