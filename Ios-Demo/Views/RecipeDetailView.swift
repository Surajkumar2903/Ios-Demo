//
//  RecipeDetailView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//



import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var recipeVM: RecipeViewModel
    
    // Orange theme colors
    private let accentOrange = Color.orange
    private let backgroundOrange = Color.orange.opacity(0.1)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image
                recipeImage(recipe: recipe)
                    .frame(height: 300)
                
                // Title
                Text(recipe.title)
                    .font(.title)
                    .bold()
                    .foregroundColor(accentOrange)
                    .padding(.horizontal)
                
                // Author
                Text("By \(recipe.author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                // Description
                Text(recipe.description)
                    .font(.body)
                    .padding(.horizontal)
                
                // Interactions
                HStack(spacing: 20) {
                    likeButton(recipe: recipe)
                    shareButton(recipe: recipe)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func recipeImage(recipe: Recipe) -> some View {
        Group {
            if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
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
                Text("\(recipe.likes) Likes")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func shareButton(recipe: Recipe) -> some View {
        ShareLink(item: "Check out this recipe: \(recipe.title) by \(recipe.author)\n\(recipe.description)") {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.gray)
                Text("Share")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Preview
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Recipe(title: "Sample", description: "Desc", imageURL: nil, author: "Author", likes: 0))
            .environmentObject(RecipeViewModel())
    }
}
