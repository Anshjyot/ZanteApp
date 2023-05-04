import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct AudioPicker: UIViewControllerRepresentable {
    @Binding var showAudioPicker: Bool
    @Binding var audioData: Data?
    @Binding var selectedAudioFileName: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

  class Coordinator: NSObject, UIDocumentPickerDelegate {
      var parent: AudioPicker

      init(_ parent: AudioPicker) {
          self.parent = parent
      }

      func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
          guard let url = urls.first else { return }
          if url.startAccessingSecurityScopedResource() {
              if let data = try? Data(contentsOf: url) {
                  self.parent.selectedAudioFileName = url.lastPathComponent
                  self.parent.audioData = data
              }
              url.stopAccessingSecurityScopedResource()
          }
          self.parent.showAudioPicker = false
      }

      func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
          self.parent.showAudioPicker = false
      }
  }

}

