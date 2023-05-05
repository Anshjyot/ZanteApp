//
//  MessageButton.swift
//  Zante
//
//  Created by Anshjyot Singh on 29/04/2023.
//

import SwiftUI

struct MessageButton: View {
    var body: some View {
        Image(systemName: "message.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(.primary)
    }
}

