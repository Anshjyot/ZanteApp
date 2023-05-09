import SwiftUI
import AVFoundation

// https://developer.apple.com/documentation/avfaudio/avaudioplayer
// https://medium.com/swift-productions/swiftui-play-an-audio-with-avaudioplayer-1c4085e2052c

struct AudioPlayerView: View {
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
        guard let url = URL(string: post.mediaUrl) else { return } // post mediaUrl is valid
        let asset = AVAsset(url: url) // Creating AVAsset with the mediaUrl
        let generator = AVAssetImageGenerator(asset: asset) // Create AVAssetImageGenerator with the asset
        generator.appliesPreferredTrackTransform = true // generator applies the preferred track transform

        do { // // Generate thumbnail image at time 0
            let imageRef = try generator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
          // Convert imageRef to UIImage and store in thumbnailImage
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

