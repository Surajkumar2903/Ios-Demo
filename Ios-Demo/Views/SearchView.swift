//
//  SearchView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//


import SwiftUI

struct SearchView: View {
    @EnvironmentObject var recipeVM: RecipeViewModel
    @State private var searchText = ""
    
    // Orange theme colors
    private let accentOrange = Color.orange
    private let backgroundOrange = Color.orange.opacity(0.1)
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipeVM.recipes
        } else {
            return recipeVM.recipes.filter { $0.title.lowercased().contains(searchText.lowercased()) || $0.description.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                if filteredRecipes.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(filteredRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            recipeCard(recipe: recipe)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search Recipes")
        }
    }
    
    private func recipeCard(recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image placeholder
            recipeImage(recipe: recipe)
            
            // Title and description
            Text(recipe.title)
                .font(.headline)
                .foregroundColor(accentOrange)
            
            Text(recipe.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Author
            Text("By \(recipe.author)")
                .font(.caption)
                .foregroundColor(.gray)
            
            // Interactions
            HStack(spacing: 20) {
                likeButton(recipe: recipe)
                shareButton(recipe: recipe)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .animation(.easeInOut, value: recipe.isLiked)
    }
    
    private func recipeImage(recipe: Recipe) -> some View {
        Group {
            if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    placeholderImage()
                }
            } else {
                placeholderImage()
            }
        }
    }
    
    private func placeholderImage() -> some View {
        Rectangle()
            .fill(backgroundOrange)
            .frame(height: 200)
            .cornerRadius(12)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            )
    }
    
    private func likeButton(recipe: Recipe) -> some View {
        Button(action: {
            recipeVM.likeRecipe(id: recipe.id)
        }) {
            HStack {
                Image(systemName: recipe.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(recipe.isLiked ? .red : .gray)
                    .scaleEffect(recipe.isLiked ? 1.2 : 1.0)
                    .animation(.spring(), value: recipe.isLiked)
                Text("\(recipe.likes)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func shareButton(recipe: Recipe) -> some View {
        ShareLink(item: "Check out this recipe: \(recipe.title) by \(recipe.author)") {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.gray)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search recipes...", text: $text)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(RecipeViewModel())
    }
}
