//
//  RecipeDetailView.swift
//  BellaRecipeRecommender
//
//  View for displaying recipe details
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.openURL) var openURL
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header Image
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    switch phase {
                    case .empty:
                        SkeletonView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.gray.opacity(0.3)
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(height: 250)
                .clipped()
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Favorite
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(recipe.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(recipe.source)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: { isFavorite.toggle() }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isFavorite ? .red : .gray)
                        }
                    }
                    
                    // Stats
                    HStack(spacing: 20) {
                        VStack(alignment: .center, spacing: 4) {
                            Text(String(format: "%.0f%%", recipe.matchPercentage))
                                .font(.headline)
                                .foregroundColor(.orange)
                            Text("Match")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text(recipe.difficulty.rawValue)
                                .font(.headline)
                            Text("Difficulty")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        if let servings = recipe.servings {
                            VStack(alignment: .center, spacing: 4) {
                                Text("\(servings)")
                                    .font(.headline)
                                Text("Servings")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                    
                                    Text(ingredient)
                                        .font(.body)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    // Instructions
                    if let instructions = recipe.instructions {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.headline)
                            
                            Text(instructions)
                                .font(.body)
                                .lineSpacing(4)
                                .foregroundColor(.black.opacity(0.8))
                        }
                    }
                    
                    // View Recipe Button
                    Button(action: {
                        if let url = URL(string: recipe.url) {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Text("View Full Recipe")
                                .font(.headline)
                            Image(systemName: "arrow.up.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.orange)
                        .cornerRadius(10)
                    }
                }
                .padding(16)
            }
        }
        .background(Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.91, alpha: 1)))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe(
            id: "1",
            name: "Sample Recipe",
            image: "https://www.themealdb.com/images/media/meals/k0n4dj1585350477.jpg",
            source: "Sample",
            url: "https://www.themealdb.com",
            ingredients: ["Ingredient 1", "Ingredient 2", "Ingredient 3"],
            instructions: "Mix ingredients and cook",
            prepTime: 15,
            cookTime: 30,
            servings: 4,
            difficulty: .medium,
            tags: ["tag1", "tag2"],
            nutrition: nil,
            matchedIngredients: 2,
            totalIngredients: 3
        ))
    }
}
