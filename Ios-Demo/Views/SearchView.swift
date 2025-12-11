//
//  SearchView.swift
//  Ios-Demo
//
//  Updated for perfect card behavior like Instagram/App Store
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var recipeVM: RecipeViewModel
    @State private var searchText = ""
    
    private let accentOrange = Color.orange
    private let backgroundOrange = Color.orange.opacity(0.1)
    
    var filteredRecipes: [Recipe] {
        guard !searchText.isEmpty else { return [] }
        
        let query = searchText.lowercased()
        return recipeVM.recipes.filter {
            $0.title.lowercased().contains(query) ||
            $0.description.lowercased().contains(query)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Search Bar
                SearchBar(text: $searchText)
                    .padding()
                    .background(Color(.orange))
                
                // Content
                if searchText.isEmpty {
                    emptyStartState
                } else if filteredRecipes.isEmpty {
                    noResultsState
                } else {
                    resultsGrid
                }
            }
            .navigationTitle("Search Recipes")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Empty Start State
    private var emptyStartState: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.4))
            
            Text("Search for recipes")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Text("Try \"Pizza\", \"Salad\", \"Chocolate\", or any ingredient")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - No Results State
    private var noResultsState: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("No recipes found")
                .font(.title3.bold())
            
            Text("Try searching for \"\(searchText)\" with different words")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Search Results Grid (This is the magic fix)
    private var resultsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(filteredRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        RecipeCard(recipe: recipe)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Beautiful Card (now works perfectly)
    @ViewBuilder
    private func RecipeCard(recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            recipeImage(recipe: recipe)
                .frame(height: 180)
                .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(accentOrange)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(recipe.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("By \(recipe.author)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        likeButton(recipe: recipe)
                        shareButton(recipe: recipe)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func recipeImage(recipe: Recipe) -> some View {
        Group {
            if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        placeholderImage()
                    }
                }
            } else {
                placeholderImage()
            }
        }
        .cornerRadius(12)
        .overlay(
            Rectangle()
                .fill(LinearGradient(stops: [
                    .init(color: .black.opacity(0.3), location: 0),
                    .init(color: .clear, location: 0.4)
                ], startPoint: .top, endPoint: .bottom))
                .cornerRadius(12)
        )
    }
    
    private func placeholderImage() -> some View {
        Rectangle()
            .fill(backgroundOrange)
            .overlay(
                Image(systemName: "photo")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.7))
            )
    }
    
    private func likeButton(recipe: Recipe) -> some View {
        Button {
            recipeVM.likeRecipe(id: recipe.id)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: recipe.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(recipe.isLiked ? .red : .gray)
                Text("\(recipe.likes)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func shareButton(recipe: Recipe) -> some View {
        ShareLink(item: "Check out this recipe: \(recipe.title) by \(recipe.author)!") {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Search Bar with nice focus ring
struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search recipes...", text: $text)
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(14)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? accentOrange : Color.clear, lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    private var accentOrange: Color { .orange }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(RecipeViewModel())
    }
}
