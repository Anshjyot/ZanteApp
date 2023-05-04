import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct PostCardImage: View {
  var post: PostModel
  @State private var audioPlayer: AVPlayer?

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        if let profileUrl = post.profile, let url = URL(string: profileUrl) {
          WebImage(url: url)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 60, height: 60, alignment: .center)
            .shadow(color: .gray, radius: 3)
        } else {
          Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 60, height: 60, alignment: .center)
            .shadow(color: .gray, radius: 3)
        }

        VStack(alignment: .leading, spacing: 4) {
          Text(post.username).font(.headline)
          Text((Date(timeIntervalSince1970: post.date)).timeAgo() + " ago").font(.subheadline).foregroundColor(.gray)
        }.padding(.leading, 10)
      }.padding(.leading)
        .padding(.top, 16)

      Text(post.caption)
        .lineLimit(nil)
        .padding(.leading, 16)
        .padding(.trailing, 32)

      if let mediaType = post.mediaType, mediaType == "audio", let audioUrl = post.mediaUrl, let url = URL(string: audioUrl) {
        Button(action: {
            toggleAudioPlayback(url: url)
        }) {
            Image(systemName: audioPlayer?.rate == 0 ? "play.circle.fill" : "pause.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
        }
        .padding(.top, 8)
      } else if let mediaUrl = post.mediaUrl, let url = URL(string: mediaUrl) {
        WebImage(url: url)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .center)
          .clipped()
      } else {
        Image(systemName: "photo.fill")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .center)
          .clipped()
      }
    }
  }

  func toggleAudioPlayback(url: URL) {
      print("Toggling audio playback")

      if audioPlayer == nil || audioPlayer?.rate == 0 {
          print("Attempting to play audio from: \(url)")

          let asset = AVAsset(url: url)
          let playerItem = AVPlayerItem(asset: asset)

          audioPlayer = AVPlayer(playerItem: playerItem)
          audioPlayer?.play()

          print("Audio player state: \(audioPlayer?.rate ?? -1)")
      } else {
          print("Pausing audio playback")
          audioPlayer?.pause()
      }
  }

  init(post: PostModel) {
          self.post = post
          setupAudioSession()
      }

      func setupAudioSession() {
          do {
              try AVAudioSession.sharedInstance().setCategory(.playback)
              try AVAudioSession.sharedInstance().setActive(true)
          } catch {
              print("Failed to set up audio session:  \(error)")
          }
      }



}

