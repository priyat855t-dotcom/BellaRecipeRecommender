//
//  APIConstants.swift
//  BellaRecipeRecommender
//
//  API configuration and constants
//

import Foundation

struct APIConstants {
    // TheMealDB - Free API (no key required)
    static let themealdbBaseURL = "https://www.themealdb.com/api/json/v1/1"
    
    // Spoonacular - Free tier (requires API key)
    // Sign up at: https://spoonacular.com/food-api
    static let spoonacularBaseURL = "https://api.spoonacular.com"
    static let spoonacularAPIKey = "YOUR_API_KEY_HERE" // Replace with your key
    
    // Endpoints
    struct TheMealDB {
        static func searchByIngredient(_ ingredient: String) -> String {
            return "\(themealdbBaseURL)/filter.php?i=\(ingredient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        static func getRecipeDetails(_ mealID: String) -> String {
            return "\(themealdbBaseURL)/lookup.php?i=\(mealID)"
        }
        
        static func searchByName(_ name: String) -> String {
            return "\(themealdbBaseURL)/search.php?s=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
    }
    
    struct Spoonacular {
        static func searchByIngredients(_ ingredients: [String], number: Int = 10) -> String {
            let ingredientList = ingredients.joined(separator: ",+")
            return "\(spoonacularBaseURL)/recipes/findByIngredients?ingredients=\(ingredientList)&number=\(number)&apiKey=\(spoonacularAPIKey)"
        }
        
        static func getRecipeInformation(_ recipeID: Int) -> String {
            return "\(spoonacularBaseURL)/recipes/\(recipeID)/information?apiKey=\(spoonacularAPIKey)"
        }
        
        static func getNutritionInfo(_ recipeID: Int) -> String {
            return "\(spoonacularBaseURL)/recipes/\(recipeID)/nutritionWidget.json?apiKey=\(spoonacularAPIKey)"
        }
    }
}
