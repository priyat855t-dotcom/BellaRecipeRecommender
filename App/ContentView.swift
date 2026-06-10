//
//  ContentView.swift
//  BellaRecipeRecommender
//
//  Main navigation view for the app
//

import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel = RecipeListViewModel()
    @State private var showingIngredientInput = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0.95, green: 0.93, blue: 0.88, alpha: 1)), Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.91, alpha: 1))]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🍳 Bella")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Find recipes with ingredients you have")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    
                    if recipeViewModel.recipes.isEmpty {
                        // Empty State
                        VStack(spacing: 30) {
                            Image(systemName: "magnifyingglass.circle")
                                .font(.system(size: 80))
                                .foregroundColor(.orange)
                            
                            Text("No Recipes Yet")
                                .font(.headline)
                            
                            Text("Enter your available ingredients to get personalized recipe recommendations")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            Button(action: { showingIngredientInput = true }) {
                                Text("Add Ingredients")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            }
                            .padding(20)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    } else {
                        // Recipe List
                        RecipeListView(viewModel: recipeViewModel)
                    }
                }
                
                // Floating Action Button
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: { showingIngredientInput = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            Spacer()
                        }
                        .padding(20)
                    }
                }
            }
            .sheet(isPresented: $showingIngredientInput) {
                IngredientInputView(viewModel: recipeViewModel, isPresented: $showingIngredientInput)
            }
        }
    }
}

#Preview {
    ContentView()
}
