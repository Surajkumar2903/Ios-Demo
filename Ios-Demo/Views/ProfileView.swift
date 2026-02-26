//
//  ProfileView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar on 11/12/25.
import SwiftUI
struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var recipeVM: RecipeViewModel
    
    @State private var showFeedbackSheet = false     // ← new
    
    private let accentOrange = Color.orange
    
    var body: some View {
        NavigationStack {
            List {
                // User Info Header (unchanged)
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(accentOrange.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(String(authManager.currentUserDisplayName.prefix(1)).uppercased())
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(accentOrange)
                            )
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(authManager.currentUserDisplayName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(authManager.currentUserEmail)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                // My Content (unchanged)
                Section("My Content") {
                    NavigationLink(destination: MyRecipesView()) {
                        Label {
                            HStack {
                                Text("My Recipes")
                                Spacer()
                                Text("\(recipeVM.userRecipes.count)")
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "fork.knife.circle.fill")
                                .foregroundColor(accentOrange)
                        }
                    }
                    
                    NavigationLink(destination: LikedRecipesView()) {
                        Label {
                            HStack {
                                Text("Liked Recipes")
                                Spacer()
                                Text("\(recipeVM.recipes.filter { $0.isLiked }.count)")
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                // ← Add new section or just a button row
                Section {
                    Button {
                        showFeedbackSheet = true
                    } label: {
                        Label("Help Improve the App", systemImage: "questionmark.circle")
                            .foregroundColor(accentOrange)
                    }
                }
                
                // Sign Out (unchanged)
                Section {
                    Button(role: .destructive) {
                        authManager.signOut { _ in }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.red.opacity(0.1))
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            
            // The survey sheet
            .sheet(isPresented: $showFeedbackSheet) {
                FeedbackSurveyView()
                    .presentationDetents([.height(600)])   // like many feedback popups
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
