//
//  DietaryRestriction.swift
//  BellaRecipeRecommender
//
//  Dietary restrictions model
//

import Foundation

enum DietaryRestriction: String, CaseIterable {
    case vegan = "Vegan"
    case vegetarian = "Vegetarian"
    case glutenFree = "Gluten-Free"
    case dairyFree = "Dairy-Free"
    case keto = "Keto"
    case paleo = "Paleo"
    case lowCarb = "Low-Carb"
    case highProtein = "High-Protein"
    
    var emoji: String {
        switch self {
        case .vegan: return "🌱"
        case .vegetarian: return "🥬"
        case .glutenFree: return "🌾"
        case .dairyFree: return "🥛"
        case .keto: return "🥑"
        case .paleo: return "🥩"
        case .lowCarb: return "📉"
        case .highProtein: return "💪"
        }
    }
}
