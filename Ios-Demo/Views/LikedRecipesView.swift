//
//  LikedRecipesView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI
struct LikedRecipesView: View {
    @EnvironmentObject var recipeVM: RecipeViewModel
    
    private var likedRecipes: [Recipe] {
        recipeVM.recipes.filter { $0.isLiked }
    }
    
    var body: some View {
        Group {
            if likedRecipes.isEmpty {
                ContentUnavailableView {
                    Label("No Likes Yet", systemImage: "heart")
                } description: {
                    Text("Recipes you like will appear here.")
                }
            } else {
                List(likedRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack {
                            recipeThumbnail(recipe)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(recipe.title)
                                    .font(.headline)
                                Text("by \(recipe.author)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Liked Recipes")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func recipeThumbnail(_ recipe: Recipe) -> some View {
        if let urlString = recipe.imageURL, let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.orange.opacity(0.2)
            }
            .clipped()
        } else {
            Color.orange.opacity(0.2)
                .overlay(Image(systemName: "photo").foregroundColor(.orange))
        }
    }
}
