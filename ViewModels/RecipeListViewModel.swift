//
//  RecipeListViewModel.swift
//  BellaRecipeRecommender
//
//  ViewModel for recipe list management
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var selectedIngredients: [String] = []
    @Published var selectedDietaryRestrictions: [DietaryRestriction] = []
    @Published var searchText: String = ""
    
    private let recipeService = RecipeService.shared
    
    func searchRecipes(for ingredients: [String]) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let foundRecipes = try await recipeService.searchRecipesByMultipleIngredients(ingredients)
            
            // Calculate matched ingredients for each recipe
            self.recipes = foundRecipes.map { recipe in
                var updatedRecipe = recipe
                let matchedCount = recipe.ingredients.filter { ingredient in
                    ingredients.contains { selectedIng in
                        ingredient.lowercased().contains(selectedIng.lowercased()) ||
                        selectedIng.lowercased().contains(ingredient.lowercased())
                    }
                }.count
                updatedRecipe.matchedIngredients = matchedCount
                return updatedRecipe
            }.sorted { $0.matchPercentage > $1.matchPercentage }
            
            applyFilters()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func addDietaryRestriction(_ restriction: DietaryRestriction) {
        if !selectedDietaryRestrictions.contains(restriction) {
            selectedDietaryRestrictions.append(restriction)
            applyFilters()
        }
    }
    
    func removeDietaryRestriction(_ restriction: DietaryRestriction) {
        selectedDietaryRestrictions.removeAll { $0 == restriction }
        applyFilters()
    }
    
    func applyFilters() {
        var filtered = recipes
        
        // Filter by dietary restrictions
        if !selectedDietaryRestrictions.isEmpty {
            filtered = recipeService.filterRecipesByDietaryRestrictions(filtered, restrictions: selectedDietaryRestrictions)
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.contains { ingredient in
                    ingredient.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        self.filteredRecipes = filtered
    }
    
    func clearAll() {
        recipes = []
        filteredRecipes = []
        selectedIngredients = []
        selectedDietaryRestrictions = []
        searchText = ""
        errorMessage = nil
    }
}
