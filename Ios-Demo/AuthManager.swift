//
//  AuthManager.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//
//
//  AuthManager.swift
//  Ios-Demo
//

import SwiftUI
import FirebaseAuth
internal import Combine

class AuthManager: NSObject, ObservableObject {

    @Published var isUserLoggedIn = false
    @Published var firebaseUserId: String = ""
    @Published var currentUserEmail: String = ""
    @Published var currentUserDisplayName: String = "User"

    private var handle: AuthStateDidChangeListenerHandle?

    override init() {
        super.init()
        setupAuthListener()
    }

    private func setupAuthListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if let user = user {
                self.isUserLoggedIn = true
                self.firebaseUserId = user.uid
                self.currentUserEmail = user.email ?? ""

                self.currentUserDisplayName =
                    user.displayName ??
                    user.email?.components(separatedBy: "@").first?.capitalized ??
                    "User"

                // Load user data from Firestore
                Task {
                    await UserService.shared.createUserIfNeeded(authUser: user)
                }

            } else {
                self.isUserLoggedIn = false
                self.firebaseUserId = ""
                self.currentUserEmail = ""
                self.currentUserDisplayName = "User"
                UserService.shared.currentUser = nil
            }
        }
    }

    // MARK: - Auth Actions

    func createAccount(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                Task {
                    await UserService.shared.createUserIfNeeded(authUser: user)
                }
            }
            completion(error)
        }
    }

    func signInWithEmail(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                Task {
                    await UserService.shared.loadUser(uid: user.uid)
                }
            }
            completion(error)
        }
    }

    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            UserService.shared.currentUser = nil
            completion(nil)
        } catch {
            completion(error)
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
