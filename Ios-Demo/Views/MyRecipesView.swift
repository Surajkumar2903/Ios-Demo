//
//  MyRecipesView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI
struct MyRecipesView: View {
    @EnvironmentObject var recipeVM: RecipeViewModel
    
    var body: some View {
        Group {
            if recipeVM.userRecipes.isEmpty {
                ContentUnavailableView {
                    Label("No Recipes Yet", systemImage: "tray")
                } description: {
                    Text("Your posted recipes will appear here.")
                }
            } else {
                List(recipeVM.userRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack {
                            recipeThumbnail(recipe)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(recipe.title)
                                    .font(.headline)
                                Text("Posted by you")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("My Recipes")
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
