//
//  FirebaseRecipeService.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//


import Foundation
import FirebaseFirestore
import FirebaseDatabase

struct FirebaseRecipeService {
    private let db = Firestore.firestore()
    private let collection = "recipes"

    func addRecipe(_ recipe: Recipe) async throws {
        try db.collection(collection)
            .document(recipe.id ?? "66")
            .setData(from: recipe)
    }

    func fetchRecipes() async throws -> [Recipe] {
        let snapshot = try await db.collection(collection)
            .order(by: "timestamp", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Recipe.self)
        }
    }
}
