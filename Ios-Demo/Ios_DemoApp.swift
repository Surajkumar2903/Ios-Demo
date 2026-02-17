//
//  Ios_DemoApp.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI
import FirebaseCore
import AppStorys_iOS

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Ios_DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                            if authManager.isUserLoggedIn {
                                ContentView()
                                    .withAppStorysOverlays()
                                    .task {
                                        AppStorys.initialize(
                                            accountID: "4350bf8e-0c9a-46bd-b953-abb65ab21d11",
                                            appID: "9e1b21a2-350a-4592-918c-2a19a73f249a",
                                            userID: "Suaj_SDK_V1"
                                        )
                                    }
                                
                            } else {
                                SignInView()
                            }
                        }
            .environmentObject(authManager)
        }
    }
}
