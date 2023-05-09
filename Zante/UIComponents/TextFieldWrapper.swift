import SwiftUI
import UIKit


// when you tap return, you escape the keyboard

struct TextView: UIViewRepresentable {
    @Binding var text: String

    // Communication between UIKit and SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // UITextView and set its properties
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .yes
        textView.returnKeyType = .done
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }

    // Update the UITextView with new text
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    // Coordinator to handle UITextView delegate methods
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ parent: TextView) {
            self.parent = parent
        }

        // Updating the SwiftUI state with the new text
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        // Dismiss the keyboard when the return key is tapped
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
}
