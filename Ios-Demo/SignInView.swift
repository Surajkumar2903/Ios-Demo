//
//  SignInView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI
struct SignInView: View {

    // MARK: - Properties

    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false

    // MARK: - Body

    var body: some View {
        VStack {
            // Email Text Field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Password Secure Field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Sign In Button
            Button(action: {
                isSigningIn = true
                authManager.signInWithEmail(withEmail: email, password: password, completion: { error in
                    handleAuthenticationResult(error)
                    isSigningIn = false
                })
            }) {
                if isSigningIn {
                    ProgressView()
                } else {
                    Text("Sign In")
                }
            }
            .frame(width: 200, height: 40)
            .background(Color.black)
            .padding(.vertical, 20)

            // Navigation Link to SignUpView
            NavigationLink(destination: SignUpView(), label: {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            })
        }
        .padding(.horizontal, 10)
        .navigationTitle("Sign In")
    }

    // MARK: - Handle Authentication Result

    private func handleAuthenticationResult(_ error: Error?) {
        if let error = error {
            // Handle sign-in error
            print("Sign-in error: \(error.localizedDescription)")
        } else {
            print("Signed in successfully!")
        }
        // Show result
    }
}

// MARK: - Preview

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
