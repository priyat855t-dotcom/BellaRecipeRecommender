//
//  Recipe.swift
//  BellaRecipeRecommender
//
//  Recipe model structure
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: String
    let name: String
    let image: String
    let source: String
    let url: String
    let ingredients: [String]
    let instructions: String?
    let prepTime: Int?
    let cookTime: Int?
    let servings: Int?
    let difficulty: DifficultyLevel
    let tags: [String]
    let nutrition: NutritionInfo?
    let matchedIngredients: Int
    let totalIngredients: Int
    
    enum DifficultyLevel: String, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    var matchPercentage: Double {
        guard totalIngredients > 0 else { return 0 }
        return Double(matchedIngredients) / Double(totalIngredients) * 100
    }
    
    var totalTime: Int? {
        guard let prep = prepTime, let cook = cookTime else { return nil }
        return prep + cook
    }
}

struct NutritionInfo: Codable {
    let calories: Double?
    let protein: Double?
    let carbs: Double?
    let fat: Double?
    let fiber: Double?
    let score: Double? // 0-100 health score
    
    var healthScoreDisplay: String {
        guard let score = score else { return "N/A" }
        return String(format: "%.0f", score)
    }
}

struct Ingredient: Identifiable, Codable {
    let id: String
    let name: String
    let quantity: String?
    let unit: String?
    let availability: AvailabilityStatus
    
    enum AvailabilityStatus: String, Codable {
        case available
        case missing
    }
}
