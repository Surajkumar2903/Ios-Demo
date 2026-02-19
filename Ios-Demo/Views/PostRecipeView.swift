//
//  PostRecipeView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
//


import SwiftUI
import AppStorys_iOS
struct PostRecipeView: View {
    @EnvironmentObject var recipeVM: RecipeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var imageURL: String? = nil // For demo, optional URL input
    
    // Orange theme colors
    private let accentOrange = Color.orange
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 150)
                }
                
                Section(header: Text("Image (Optional)")) {
                    TextField("Image URL", text: Binding(
                        get: { imageURL ?? "" },
                        set: { imageURL = $0.isEmpty ? nil : $0 }
                    ))
                }
            }
           // .trackAppStorysScreen("Suraj Home Screen iOS")
            .navigationTitle("Post Recipe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") {
                        let newRecipe = Recipe(
                            title: title,
                            description: description,
                            imageURL: imageURL,
                            author: "Suraj", // TODO: Use authManager.userName
                            likes: 0
                        )
                        recipeVM.addRecipe(newRecipe)
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                    .foregroundColor(accentOrange)
                }
            }
           // .trackAppStorysScreen("Suraj Home Screen iOS")
        }
      


    }
}

// MARK: - Preview
struct PostRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        PostRecipeView()
            .environmentObject(RecipeViewModel())
    }
}
