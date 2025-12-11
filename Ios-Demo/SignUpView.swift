//
//  SignUpView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI
struct SignUpView: View {

    // MARK: - Properties

    @EnvironmentObject var authManager: AuthManager
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningUp = false

    // MARK: - Body

    var body: some View {
        VStack {
            // Email Text Field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Password Secure Field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Sign Up Button
            Button(action: {
                isSigningUp = true
                authManager.createAccount(withEmail: email, password: password, completion: { error in
                    handleAuthenticationResult(error)
                    isSigningUp = false
                })
            }) {
                if isSigningUp {
                    ProgressView()
                } else {
                    Text("Sign Up")
                }
            }
            .frame(width: 200, height: 40)
            .background(Color.black)
            .padding(.vertical, 20)

            // Navigate back to SignInView
            Text("Already have an account? Sign In")
                .foregroundColor(.blue)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .padding(.horizontal, 10)
        .navigationTitle("Sign Up")
    }

    // MARK: - Handle Authentication Result

    private func handleAuthenticationResult(_ error: Error?) {
        if let error = error {
            print("Sign-up error: \(error.localizedDescription)")
            // Show error
        } else {
            print("Signed up successfully!")
        }
        // Show result
    }
}

// MARK: - Preview

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
