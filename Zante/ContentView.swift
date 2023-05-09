//
//  ContentView.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/03/2023.
//

import SwiftUI

// main view of the app

struct ContentView: View {

  @EnvironmentObject var session: SessionViewModel

  func listen() {
    session.listen()
  }

  var body: some View {
    Group{
      if(session.session != nil) { // checks if there is an authenticated user or not and renders either HomeView or LogInView accordingly
        HomeView()
      } else {
        LogInView()
      }
    }.onAppear(perform: listen) // listens to changes in the authentication state
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


