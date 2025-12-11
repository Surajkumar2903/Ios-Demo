//
//  RecipeViewModel.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import Foundation
internal import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var userRecipes: [Recipe] = [] // For profile
    
    init() {
        loadDummyData()
    }
    
    private func loadDummyData() {
        // Dummy recipes for feed display
        let dummyRecipes = [
            Recipe(
                title: "Classic Spaghetti Carbonara",
                description: "Ingredients: Spaghetti, eggs, pancetta, Parmesan cheese, black pepper. Instructions: Boil pasta, mix with egg mixture, add pancetta.",
                imageURL: nil, // Can add a URL later, e.g., "https://example.com/carbonara.jpg"
                author: "Chef John",
                likes: 42
            ),
            Recipe(
                title: "Vegan Avocado Toast",
                description: "Ingredients: Bread, avocado, lemon, cherry tomatoes, salt. Instructions: Toast bread, mash avocado with lemon, top with tomatoes.",
                imageURL: nil,
                author: "HealthyEats",
                likes: 28
            ),
            Recipe(
                title: "Chocolate Chip Cookies",
                description: "Ingredients: Flour, butter, sugar, chocolate chips, eggs. Instructions: Mix dry and wet ingredients, bake at 350°F for 10-12 mins.",
                imageURL: nil,
                author: "BakerJane",
                likes: 65
            ),
            Recipe(
                title: "Grilled Cheese Sandwich",
                description: "Ingredients: Bread, cheese, butter. Instructions: Butter bread, add cheese, grill until golden.",
                imageURL: nil,
                author: "QuickMeals",
                likes: 19
            ),
            Recipe(
                title: "Fresh Garden Salad",
                description: "Ingredients: Lettuce, tomatoes, cucumber, olive oil, vinegar. Instructions: Chop veggies, toss with dressing.",
                imageURL: nil,
                author: "VeggieLover",
                likes: 37
            )
        ]
        
        recipes = dummyRecipes
        // Assume some are user's recipes for profile demo
        userRecipes = Array(dummyRecipes.prefix(2))
    }
    
    func likeRecipe(id: UUID) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes[index].isLiked.toggle()
            recipes[index].likes += recipes[index].isLiked ? 1 : -1
        }
        if let index = userRecipes.firstIndex(where: { $0.id == id }) {
            userRecipes[index].isLiked.toggle()
            userRecipes[index].likes += userRecipes[index].isLiked ? 1 : -1
        }
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        userRecipes.append(recipe)
    }
    
}
extension RecipeViewModel {
    var likedRecipes: Int {
        recipes.filter { $0.isLiked }.count
    }
}
