//
//  FeedView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var recipeVM: RecipeViewModel
    @State private var showingPostView = false
    
    private let accentOrange = Color.orange
    private let lightOrange = Color.orange.opacity(0.15)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if recipeVM.recipes.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(recipeVM.recipes) { recipe in
                            RedditStyleRecipeCard(recipe: recipe)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle("Recipe Feed")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingPostView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(accentOrange)
                    }
                }
            }
            .sheet(isPresented: $showingPostView) {
                PostRecipeView()
            }
        }
    }
    
    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No recipes yet")
                .font(.title2)
                .fontWeight(.medium)
            Text("Be the first to share a delicious recipe!")
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Reddit-Style Card
struct RedditStyleRecipeCard: View {
    let recipe: Recipe
    @EnvironmentObject var recipeVM: RecipeViewModel
    
    private let accentOrange = Color.orange
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header: Author + Time ago
            HStack(spacing: 8) {
                Circle()
                    .fill(accentOrange)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(String(recipe.author.prefix(1)).uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(recipe.author)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("2 hours ago")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Title
            Text(recipe.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(accentOrange)
                .padding(.horizontal)
                .padding(.top, 8)
            
            // Description (preview)
            Text(recipe.description)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(4)
                .padding(.horizontal)
                .padding(.top, 6)
            
            // Image (if exists)
            if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 300)
                            .clipped()
                    case .empty:
                        placeholderImage
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 10)
            } else {
                placeholderImage
                    .padding(.horizontal)
                    .padding(.top, 10)
            }
            
            HStack(spacing: 20) {
                HStack(spacing: 8) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            recipeVM.likeRecipe(id: recipe.id)
                        }
                    } label: {
                        Image(systemName: recipe.isLiked ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(recipe.isLiked ? .red : .black)
                    }
                    
                    Text("\(recipe.likes)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(recipe.isLiked ? .red :
                                .black)
                }
                
                // Comments
                HStack(spacing: 6) {
                    Image(systemName: "message")
                        .font(.title2)
                        .foregroundColor(.black)
                    Text("\(recipe.comments.count)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
            
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        .onTapGesture {
        }
    }
    
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.orange.opacity(0.2))
            .frame(height: 220)
            .cornerRadius(12)
            .overlay(
                Image(systemName: "fork.knife")
                    .font(.system(size: 50))
                    .foregroundColor(accentOrange.opacity(0.6))
            )
    }
}

// MARK: - Preview
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
            .environmentObject(RecipeViewModel())
    }
}
