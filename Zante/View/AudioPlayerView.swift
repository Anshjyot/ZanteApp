//
//  AudioPlayerView.swift
//  Zante
//
//  Created by Anshjyot Singh on 20/04/2023.
//

import SwiftUI
import AVKit

struct AudioPlayerView: View {
    let url: URL

    var body: some View {
        VStack {
            Text("Audio Post")
            VideoPlayer(player: AVPlayer(url: url))
                .frame(height: 200)
                .cornerRadius(10)
                .padding()
        }
    }
}

