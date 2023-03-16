//
//  ContentView.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/03/2023.
//

import SwiftUI

struct ContentView: View {
  @State private var mail = ""
  @State private var password = ""

  var body: some View {
    LogInView()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


