import SwiftUI
import AVKit

struct AudioPlayerView: View {
    let audioURL: URL
    @State private var player: AVPlayer?

    var body: some View {
        VStack {
            if player != nil {
                VideoPlayer(player: player)
                .frame(height: 40)
                .onAppear {
                    player?.play()
                }
                .onDisappear {
                    player?.pause()
                }
        }
    }
    .onAppear {
        self.player = AVPlayer(url: audioURL)
    }
    .onDisappear {
        self.player = nil
    }
}
}

