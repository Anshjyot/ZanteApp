//
//  ContentView.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/03/2023.
//

import SwiftUI

struct ContentView: View {

  @EnvironmentObject var session: SessionStore

  func listen() {
    session.listen()
  }

  var body: some View {
    Group{
      if(session.session != nil) {
        HomeView()
      } else {
        LogInView()
      }
    }.onAppear(perform: listen)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


