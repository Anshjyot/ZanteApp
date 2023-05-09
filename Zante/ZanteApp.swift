//
//  ZanteApp.swift
//  Zante
//
//  Created by Anshjyot Singh on 09/03/2023.
//

import SwiftUI
import Firebase

// main app struct
@main
struct ZanteApp: App {

    // initialize app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // app's main scene
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SessionViewModel())
        }
    }
}

// app delegate
class AppDelegate: NSObject, UIApplicationDelegate {

    // Configure Firebase when the app finishes launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {


        print("Firebase..")
        FirebaseApp.configure()
        return true
    }
}


