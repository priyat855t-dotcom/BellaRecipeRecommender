//
//  IngredientInputView.swift
//  BellaRecipeRecommender
//
//  View for ingredient input
//

import SwiftUI

struct IngredientInputView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    @Binding var isPresented: Bool
    @State private var ingredientInput: String = ""
    @State private var showError = false
    
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
                
                VStack(spacing: 16) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add Ingredients")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Enter ingredients you have at home")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                    
                    // Input Field
                    HStack {
                        TextField("Enter ingredient...", text: $ingredientInput)
                            .textFieldStyle(.roundedBorder)
                        
                        Button(action: addIngredient) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.orange)
                        }
                    }
                    
                    // Added Ingredients
                    if !viewModel.selectedIngredients.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Selected Ingredients (\(viewModel.selectedIngredients.count))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(viewModel.selectedIngredients, id: \.self) { ingredient in
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                            
                                            Text(ingredient)
                                                .font(.body)
                                            
                                            Spacer()
                                            
                                            Button(action: { removeIngredient(ingredient) }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding(10)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .frame(maxHeight: 300)
                        }
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: { isPresented = false }) {
                            Text("Cancel")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        }
                        
                        Button(action: searchRecipes) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Search Recipes")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.orange)
                        .cornerRadius(10)
                        .disabled(viewModel.selectedIngredients.isEmpty || viewModel.isLoading)
                    }
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addIngredient() {
        let cleaned = ingredientInput.trimmingCharacters(in: .whitespaces).lowercased()
        guard !cleaned.isEmpty, !viewModel.selectedIngredients.contains(cleaned) else { return }
        
        viewModel.selectedIngredients.append(cleaned)
        ingredientInput = ""
    }
    
    private func removeIngredient(_ ingredient: String) {
        viewModel.selectedIngredients.removeAll { $0 == ingredient }
    }
    
    private func searchRecipes() {
        Task {
            await viewModel.searchRecipes(for: viewModel.selectedIngredients)
            isPresented = false
        }
    }
}

#Preview {
    IngredientInputView(viewModel: RecipeListViewModel(), isPresented: .constant(true))
}
