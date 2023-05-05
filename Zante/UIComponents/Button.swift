//
//  ButtonModifiers.swift
//  Zante
//
//  Created by Anshjyot Singh on 15/03/2023.
//

import SwiftUI

struct ButtonModifiers: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(minWidth: 0, maxWidth: .infinity)
      .frame(height: 20)
      .padding()
      .foregroundColor(.white)
      .font(.system(size: 14, weight: .bold))
      .background(Color.black)
      .cornerRadius(5.0)
  }
}

