//
//  UserService.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import FirebaseFirestore
import FirebaseAuth
internal import Combine

class UserService: ObservableObject {
    static let shared = UserService()

    @Published var currentUser: User? = nil
    
    private let db = Firestore.firestore()
    private let collection = "users"

    // Create user document ONLY if it doesn't exist
    func createUserIfNeeded(authUser: FirebaseAuth.User) async {
        let ref = db.collection(collection).document(authUser.uid)

        do {
            let snapshot = try await ref.getDocument()
            
            if snapshot.exists {
                print("User already exists, loading user…")
                await loadUser(uid: authUser.uid)
                return
            }

            let newUser = User(
                id: authUser.uid,
                email: authUser.email ?? "",
                likedRecipes: [],
                uploadedRecipes: []
            )

            try ref.setData(from: newUser)
            print("✅ Created new user document in Firestore")

            await loadUser(uid: authUser.uid)

        } catch {
            print("❌ Error creating user document: \(error)")
        }
    }

    // Load user document into memory
    func loadUser(uid: String) async {
        do {
            let snapshot = try await db.collection(collection)
                .document(uid)
                .getDocument()

            let user = try snapshot.data(as: User.self)
            await MainActor.run {
                self.currentUser = user
            }

            print("📥 Loaded User from Firestore: \(user.email)")
        } catch {
            print("❌ Error loading user: \(error)")
        }
    }
}
