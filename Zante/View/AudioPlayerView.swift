//
//  AudioPlayerView.swift
//  Zante
//
//  Created by Anshjyot Singh on 20/04/2023.
//

import SwiftUI
import AVKit

struct AudioPlayerView: View {
    let audioURL: URL
    @State private var audioPlayer: AVPlayer?

    var body: some View {
        VStack {
            Button(action: {
                if let player = audioPlayer {
                    player.play()
                } else {
                    audioPlayer = AVPlayer(url: audioURL)
                    audioPlayer?.play()
                }
            }) {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}


