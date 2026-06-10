//
//  RecipeService.swift
//  BellaRecipeRecommender
//
//  Service for fetching recipes from APIs
//

import Foundation

class RecipeService {
    static let shared = RecipeService()
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - TheMealDB Models
    private struct MealSearchResponse: Codable {
        let meals: [MealBasic]?
    }
    
    private struct MealBasic: Codable {
        let idMeal: String
        let strMeal: String
        let strMealThumb: String
    }
    
    private struct MealDetailResponse: Codable {
        let meals: [MealDetail]?
    }
    
    private struct MealDetail: Codable {
        let idMeal: String
        let strMeal: String
        let strCategory: String?
        let strArea: String?
        let strInstructions: String?
        let strMealThumb: String?
        let strSource: String?
        let strTags: String?
        
        // Ingredients (up to 20)
        let strIngredient1: String?
        let strIngredient2: String?
        let strIngredient3: String?
        let strIngredient4: String?
        let strIngredient5: String?
        let strIngredient6: String?
        let strIngredient7: String?
        let strIngredient8: String?
        let strIngredient9: String?
        let strIngredient10: String?
        let strIngredient11: String?
        let strIngredient12: String?
        let strIngredient13: String?
        let strIngredient14: String?
        let strIngredient15: String?
        let strIngredient16: String?
        let strIngredient17: String?
        let strIngredient18: String?
        let strIngredient19: String?
        let strIngredient20: String?
        
        func getIngredients() -> [String] {
            let ingredients = [
                strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
                strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
                strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
                strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
            ]
            return ingredients.compactMap { $0?.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        }
    }
    
    // MARK: - Public Methods
    
    func searchRecipesByIngredient(_ ingredient: String) async throws -> [Recipe] {
        let urlString = APIConstants.TheMealDB.searchByIngredient(ingredient)
        guard let url = URL(string: urlString) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let response: MealSearchResponse = try await networkManager.fetch(url: url)
        guard let meals = response.meals else {
            return []
        }
        
        var recipes: [Recipe] = []
        
        for meal in meals {
            if let recipe = try await getRecipeDetails(mealID: meal.idMeal) {
                recipes.append(recipe)
            }
        }
        
        return recipes
    }
    
    func getRecipeDetails(mealID: String) async throws -> Recipe? {
        let urlString = APIConstants.TheMealDB.getRecipeDetails(mealID)
        guard let url = URL(string: urlString) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let response: MealDetailResponse = try await networkManager.fetch(url: url)
        guard let meals = response.meals, let meal = meals.first else {
            return nil
        }
        
        let ingredients = meal.getIngredients()
        
        return Recipe(
            id: meal.idMeal,
            name: meal.strMeal,
            image: meal.strMealThumb ?? "",
            source: meal.strArea ?? "Unknown",
            url: meal.strSource ?? "https://www.themealdb.com",
            ingredients: ingredients,
            instructions: meal.strInstructions,
            prepTime: nil,
            cookTime: nil,
            servings: nil,
            difficulty: determineDifficulty(instructions: meal.strInstructions),
            tags: (meal.strTags?.split(separator: ",").map(String.init)) ?? [],
            nutrition: nil,
            matchedIngredients: 0,
            totalIngredients: ingredients.count
        )
    }
    
    func searchRecipesByMultipleIngredients(_ ingredients: [String]) async throws -> [Recipe] {
        var allRecipes: [Recipe] = []
        var recipeIDs: Set<String> = []
        
        for ingredient in ingredients {
            let recipes = try await searchRecipesByIngredient(ingredient)
            for recipe in recipes {
                if !recipeIDs.contains(recipe.id) {
                    recipeIDs.insert(recipe.id)
                    allRecipes.append(recipe)
                }
            }
        }
        
        return allRecipes
    }
    
    func filterRecipesByDietaryRestrictions(_ recipes: [Recipe], restrictions: [DietaryRestriction]) -> [Recipe] {
        guard !restrictions.isEmpty else { return recipes }
        
        return recipes.filter { recipe in
            restrictions.allSatisfy { restriction in
                matchesDietaryRestriction(recipe: recipe, restriction: restriction)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func determineDifficulty(instructions: String?) -> Recipe.DifficultyLevel {
        guard let instructions = instructions else { return .medium }
        let wordCount = instructions.split(separator: " ").count
        
        if wordCount < 50 {
            return .easy
        } else if wordCount < 150 {
            return .medium
        } else {
            return .hard
        }
    }
    
    private func matchesDietaryRestriction(recipe: Recipe, restriction: DietaryRestriction) -> Bool {
        let ingredientsLower = recipe.ingredients.map { $0.lowercased() }
        let recipeLower = (recipe.name + recipe.instructions.flatMap { $0 }).lowercased()
        
        switch restriction {
        case .vegan:
            return !ingredientsLower.contains { ingredient in
                ingredient.contains("meat") || ingredient.contains("chicken") ||
                ingredient.contains("fish") || ingredient.contains("egg") ||
                ingredient.contains("milk") || ingredient.contains("cheese") ||
                ingredient.contains("butter") || ingredient.contains("cream")
            }
        case .vegetarian:
            return !ingredientsLower.contains { ingredient in
                ingredient.contains("meat") || ingredient.contains("chicken") ||
                ingredient.contains("fish") || ingredient.contains("beef")
            }
        case .glutenFree:
            return !ingredientsLower.contains { ingredient in
                ingredient.contains("wheat") || ingredient.contains("flour") ||
                ingredient.contains("bread") || ingredient.contains("pasta")
            }
        case .dairyFree:
            return !ingredientsLower.contains { ingredient in
                ingredient.contains("milk") || ingredient.contains("cheese") ||
                ingredient.contains("butter") || ingredient.contains("cream")
            }
        case .keto:
            return recipeLower.contains("keto") || !ingredientsLower.contains { ingredient in
                ingredient.contains("sugar") || ingredient.contains("rice") ||
                ingredient.contains("pasta") || ingredient.contains("bread")
            }
        case .paleo:
            return !ingredientsLower.contains { ingredient in
                ingredient.contains("dairy") || ingredient.contains("grain") ||
                ingredient.contains("legume") || ingredient.contains("processed")
            }
        case .lowCarb:
            return !ingredientsLower.contains { ingredient in
                ingredient.contains("rice") || ingredient.contains("pasta") ||
                ingredient.contains("bread") || ingredient.contains("potato")
            }
        case .highProtein:
            return ingredientsLower.contains { ingredient in
                ingredient.contains("chicken") || ingredient.contains("beef") ||
                ingredient.contains("fish") || ingredient.contains("egg") ||
                ingredient.contains("protein")
            }
        }
    }
}
