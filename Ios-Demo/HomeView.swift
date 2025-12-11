//
//  HomeView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel = RecipeViewModel()
    
    // Orange theme colors
    private let accentOrange = Color.orange
    private let backgroundOrange = Color.orange.opacity(0.1)
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.recipes.isEmpty {
                    // Empty state (as per assignment expectations)
                    Text("No recipes yet. Be the first to post!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.recipes) { recipe in
                        VStack(alignment: .leading, spacing: 8) {
                            // Recipe Title
                            Text(recipe.title)
                                .font(.headline)
                                .foregroundColor(accentOrange)
                            
                            // Description
                            Text(recipe.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                            
                            // Author and Likes (simple social feature)
                            HStack {
                                Text("By \(recipe.author)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                HStack {
                                    Image(systemName: "heart")
                                        .foregroundColor(accentOrange)
                                    Text("\(recipe.likes)")
                                        .font(.caption)
                                }
                            }
                            
                            // Placeholder for image if URL is available (can be enhanced later)
                            if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                } placeholder: {
                                    Rectangle()
                                        .fill(backgroundOrange)
                                        .frame(height: 150)
                                        .cornerRadius(8)
                                }
                            } else {
                                Rectangle()
                                    .fill(backgroundOrange)
                                    .frame(height: 150)
                                    .cornerRadius(8)
                                    .overlay(
                                        Text("No Image")
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(PlainListStyle())
                }
                
                // Sign Out Button (kept from original)
//                Button("Sign Out") {
//                    authManager.signOut { error in
//                        if let error = error {
//                            print("Sign-out error: \(error.localizedDescription)")
//                            // TODO: Show alert for error
//                        }
//                    }
//                }
//                .frame(width: 200, height: 40)
//                .background(accentOrange)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//                .padding(.vertical, 20)
            }
            .padding(.horizontal, 10)
            .navigationTitle("Recipe Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Navigate to post recipe view
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(accentOrange)
                    }
                }
            }
        }
        .accentColor(accentOrange) // Apply orange theme to navigation
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthManager())
    }
}
