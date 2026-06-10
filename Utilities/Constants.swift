//
//  Constants.swift
//  BellaRecipeRecommender
//
//  App-wide constants
//

import Foundation

struct AppConstants {
    // API Configuration
    static let requestTimeout: TimeInterval = 30
    static let maxRecipesPerSearch = 20
    
    // Default Values
    static let defaultServingSize = 4
    static let minIngredientsForSearch = 1
    static let maxIngredientsPerSearch = 10
    
    // Common Ingredients
    static let commonIngredients = [
        "chicken", "beef", "pork", "fish", "salmon", "tuna",
        "rice", "pasta", "bread", "flour", "oats",
        "tomato", "onion", "garlic", "carrot", "potato",
        "lettuce", "spinach", "broccoli", "bell pepper",
        "milk", "cheese", "butter", "eggs", "cream",
        "olive oil", "salt", "pepper", "sugar"
    ]
    
    // URLs
    static let appName = "Bella Recipe Recommender"
    static let appVersion = "1.0.0"
}
