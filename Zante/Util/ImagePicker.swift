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
  @Binding var image: Image? //optional cause it can be a image start
  @Binding var showImage: Bool
  @Binding var imageData: Data


  func makeCoordinator() -> ImagePicker.Coordinator { //coordinator to communicate with the UIImagePickerControllerDelegate
    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> UIImagePickerController { // UIImagePickerController with the coordinator as its delegate
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    picker.allowsEditing = true
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

  }

  //  coordinator that will act as the UIImagePickerControllerDelegate
  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker


    // initialize the coordinator with a ref to the parent ImagePicker

    init(_ parent: ImagePicker) {
      self.parent = parent
    }

    
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      let uiImage = info[.editedImage] as! UIImage // Get the selected image
      parent.image = Image(uiImage: uiImage) // // Assigning it to the image property

      // compressing it to jpeg format
      if let data = uiImage.jpegData(compressionQuality: 0.5) {
        parent.imageData = data
      }

      parent.showImage = false // hiding image picker
    }
  }
}
