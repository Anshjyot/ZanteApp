import SwiftUI
import UIKit
import MobileCoreServices
import FirebaseStorage
import UniformTypeIdentifiers

struct AudioPicker: UIViewControllerRepresentable {
    @Binding var showAudioPicker: Bool
    @Binding var audioData: Data?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = [kUTTypeAudio as String, kUTTypeMP3 as String, kUTTypeMPEG4Audio as String]
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: AudioPicker

        init(_ parent: AudioPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let audioURL = info[.mediaURL] as? URL {
                parent.audioData = try? Data(contentsOf: audioURL)
            }
            parent.showAudioPicker = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showAudioPicker = false
        }
    }
}
