//
//  HomeView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI
struct HomeView: View {

    // MARK: - Properties

    @EnvironmentObject var authManager: AuthManager

    // MARK: - Body

    var body: some View {
        VStack {
            Text("Welcome to Your App!")

            // Sign Out Button
            Button("Sign Out") {
                authManager.signOut { error in
                    if let error = error {
                        print("Sign-out error: \(error.localizedDescription)")
                        // Show error
                    }
                }
            }
            .frame(width: 200, height: 40)
            .background(Color.black)
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 10)
        .navigationTitle("Home")
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
