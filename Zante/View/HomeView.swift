//
//  ContentView.swift
//  ZANTEVIDEO9
//
//  Created by Vandad Azar on 23/03/2023.
//

import SwiftUI

struct HomeView: View{
    var body: some View{
        NavigationView{
            CustomTabView()
                .navigationTitle("")
        }.accentColor(.blue)
    }
}

var tabs = ["house.fill", "magnifyingglass", "camera.viewfinder", "person.fill"]

struct CustomTabView: View{
    @State var selectedTab = "house.fill"
    @State var currentWindowScene: UIWindowScene?

    var body: some View{
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            TabView(selection: $selectedTab){
                MainView()
                    .tag("house.fill")
                Search()
                    .tag("magnifyingglass")
                PostingView()
                    .tag("camera.viewfinder")
                Profile()
                    .tag("person.fill")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all, edges: .bottom)

            HStack(spacing: 0){
                ForEach(tabs, id:\.self){ image in
                    TabButton(image: image, selectedTab: $selectedTab)

                    if image != tabs.last{
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .padding(.bottom, currentWindowScene?.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.bottom ?? 0)

        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.black.opacity(0.05).ignoresSafeArea(.all, edges: .all))
        .onAppear {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                currentWindowScene = scene
            }
        }
    }


    struct TabButton: View{
        var image: String

        @Binding var selectedTab: String

        var body: some View{
            Button(action: {selectedTab = image}){
                Image(systemName: "\(image)")
                    .foregroundColor(selectedTab == image ? Color.gray: Color.black)
                    .padding()
            }
        }
    }

}
