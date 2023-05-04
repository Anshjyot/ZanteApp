import SwiftUI
import AVFoundation

struct AudioPostCard: View {
    var post: PostModel

    @State private var audioPlayer: AVPlayer?
    @State private var thumbnailImage: UIImage? = nil

    func playAudio() {
        if let audioURL = URL(string: post.mediaUrl) {
            audioPlayer = AVPlayer(url: audioURL)
            audioPlayer?.play()
        }
    }

    func loadThumbnail() {
        guard let url = URL(string: post.mediaUrl) else { return }
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        do {
            let imageRef = try generator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            thumbnailImage = UIImage(cgImage: imageRef)
        } catch let error {
            print("Error generating thumbnail: \(error.localizedDescription)")
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Audio Post")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button(action: playAudio) {
                    Image(systemName: "play.fill")
                        .font(.title2)
                }
            }
            .padding(.horizontal)

            if let thumbnail = thumbnailImage {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            Text(post.caption)
                .padding(.horizontal)

            Spacer()
        }
        .onAppear(perform: loadThumbnail)
        .frame(height: 200)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

