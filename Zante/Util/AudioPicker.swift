import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers


// https://gitlab.com/-/snippets/2021907
struct AudioPicker: UIViewControllerRepresentable {
    @Binding var showAudioPicker: Bool
    @Binding var audioData: Data?  // selected audio file's data
    @Binding var selectedAudioFileName: String?  // selected audio file's name

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Create and configure the UIDocumentPickerViewController
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.mp3, UTType.mpeg4Audio, UTType.init(filenameExtension: "m4a")!], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }


    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    // handle events from the document picker
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: AudioPicker

        init(_ parent: AudioPicker) {
            self.parent = parent
        }

        // When a document is selected, then:
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                do {
                    self.parent.audioData = try Data(contentsOf: url)  // Get the audio file's data
                    self.parent.selectedAudioFileName = url.lastPathComponent  // Get the audio file's name
                    self.parent.showAudioPicker = false  // Hiding the audio picker
                } catch {
                    print("Error: \(error)")
                }
            }
        }

        // When user cancels the document picker
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            self.parent.showAudioPicker = false  // Hide the audio picker
        }
    }
}

