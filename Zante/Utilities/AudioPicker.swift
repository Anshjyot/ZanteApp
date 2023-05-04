import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct AudioPicker: UIViewControllerRepresentable {
    @Binding var showAudioPicker: Bool
    @Binding var audioData: Data?
    @Binding var selectedAudioFileName: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

  func makeUIViewController(context: Context) -> some UIViewController {
          let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.mp3, UTType.mpeg4Audio, UTType.init(filenameExtension: "m4a")!], asCopy: true)
          picker.delegate = context.coordinator
          return picker
      }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: AudioPicker

        init(_ parent: AudioPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                do {
                    self.parent.audioData = try Data(contentsOf: url)
                    self.parent.selectedAudioFileName = url.lastPathComponent
                    self.parent.showAudioPicker = false
                } catch {
                    print("Error: \(error)")
                }
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            self.parent.showAudioPicker = false
        }
    }
}

