//
//  RecipeViewModel.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import Foundation
import FirebaseFirestore
import FirebaseDatabase
internal import Combine
@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var userRecipes: [Recipe] = []

    private let db = Firestore.firestore()
    private let collection = "recipes"

    // MARK: - Fetch All Recipes (Feed)
    func fetchAllRecipes() async {
        do {
            let snapshot = try await db.collection(collection)
                .order(by: "timestamp", descending: true)
                .getDocuments()

            self.recipes = snapshot.documents.compactMap { doc in
                try? doc.data(as: Recipe.self)
            }
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }

    // MARK: - Fetch User Recipes (Profile)
    func fetchUserRecipes(userName: String) async {
        do {
            let snapshot = try await db.collection(collection)
                .whereField("author", isEqualTo: userName)
                .order(by: "timestamp", descending: true)
                .getDocuments()

            self.userRecipes = snapshot.documents.compactMap { doc in
                try? doc.data(as: Recipe.self)
            }
        } catch {
            print("Error fetching user recipes: \(error)")
        }
    }

    // MARK: - Add Recipe
    func addRecipe(_ recipe: Recipe) {
        Task {
            guard let id = recipe.id else { return }

            do {
                try db.collection(collection)
                    .document(id)
                    .setData(from: recipe)

                // Refresh feed & user section
                await fetchAllRecipes()
                await fetchUserRecipes(userName: recipe.author)

            } catch {
                print("Error adding recipe: \(error)")
            }
        }
    }

    // MARK: - Like / Unlike Recipe
    func toggleLike(_ recipe: Recipe) {
        guard let recipeId = recipe.id else { return }
        let newLikeState = !recipe.isLiked
        let newLikeCount = recipe.likes + (newLikeState ? 1 : -1)

        Task {
            do {
                try await db.collection(collection)
                    .document(recipeId)
                    .updateData([
                        "likes": newLikeCount
                    ])

                // Update UI in memory
                if let index = recipes.firstIndex(where: { $0.id == recipeId }) {
                    recipes[index].likes = newLikeCount
                    recipes[index].isLiked = newLikeState
                }

                if let index = userRecipes.firstIndex(where: { $0.id == recipeId }) {
                    userRecipes[index].likes = newLikeCount
                    userRecipes[index].isLiked = newLikeState
                }

            } catch {
                print("Error liking/unliking recipe: \(error)")
            }
        }
    }

    // MARK: - Count for Profile Stats
    var likedRecipesCount: Int {
        recipes.filter { $0.isLiked }.count
    }
}
