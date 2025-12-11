//
//  AuthManager.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI
import FirebaseAuth
internal import Combine

class AuthManager: NSObject, ObservableObject {

    @Published var isUserLoggedIn = false
    
    // ADD THESE TWO LINES ONLY
    @Published var currentUserEmail: String = ""
    @Published var currentUserDisplayName: String = "User"
    
    private var handle: AuthStateDidChangeListenerHandle?

    override init() {
        super.init()
        setupAuthStateChangeListener()
    }

    private func setupAuthStateChangeListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            if let user = user {
                self.isUserLoggedIn = true
                self.currentUserEmail = user.email ?? "No email"
                // Use email prefix or "User" if no displayName
                self.currentUserDisplayName = user.displayName ??
                    user.email?.components(separatedBy: "@").first?.capitalized ?? "User"
            } else {
                self.isUserLoggedIn = false
                self.currentUserEmail = ""
                self.currentUserDisplayName = "User"
            }
        }
    }

    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    // Your existing createAccount & signInWithEmail methods stay 100% unchanged
    func createAccount(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }

    func signInWithEmail(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
