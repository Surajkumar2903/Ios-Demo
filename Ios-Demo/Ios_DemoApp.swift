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
                                        AppStorysLogger.logLevel = .debug
                                                           AppStorys.enableTestMode()
                                                            AppStorys.initialize(
                                                                ///test credentials
                                                                accountID: "12a9eac5-94ee-4735-9aa6-b8a94cb8fbbb",
                                                                appID: "f69bdccf-b20f-4938-b39e-7075d76db791",
                                                                userID: "anshisthename",
                                        )
                                    }
                            
                                
//MARK: github Rules
                                
//                                    .withAppStorysOverlays()
//                                                   .task {
//                                                       // Optional: enable SDK logging for development
//                                                       AppStorysLogger.logLevel = .debug
//
//                                                       AppStorys.initialize(
//                                                           accountID: "12a9eac5-94ee-4735-9aa6-b8a94cb8fbbb",
//                                                           appID: "f69bdccf-b20f-4938-b39e-7075d76db791",
//                                                           userID: "Suaj_SDK_V1",
//                                                           baseURL: "https://users.appstorys.co"
//                                                       )
//                                                   }
                                
//MARK: Previous initialisation
//                                    .withAppStorysOverlays()
//                                    .task {
//                                        AppStorys.initialize(
//                                            accountID: "412a9eac5-94ee-4735-9aa6-b8a94cb8fbbb",
//                                            appID: "f69bdccf-b20f-4938-b39e-7075d76db791",
//                                            userID: "Suaj_SDK_V1"
//                                        )
//                                    }
                                
                            } else {
                                SignInView()
                            }
                        }
            .environmentObject(authManager)
        }
    }
}
