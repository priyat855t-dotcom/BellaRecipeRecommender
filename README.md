# Bella Recipe Recommender

## Overview
Bella is an iOS app that recommends delicious recipes based on ingredients available at home. The app provides:
- 🍳 Smart recipe recommendations
- 📊 Nutrition scores
- 🥗 Dietary restriction filters
- 🖼️ Recipe images and details
- 🔗 Direct links to full recipes

## Features

### Core Features
1. **Ingredient Input** - Users enter available ingredients
2. **Smart Recommendations** - Recipes matched based on available ingredients
3. **Nutrition Scoring** - Health score for each recipe
4. **Dietary Filters** - Vegan, Vegetarian, Gluten-Free, Keto, etc.
5. **Recipe Details** - Images, cooking time, difficulty level, and source links

## Tech Stack
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Networking**: URLSession
- **APIs**: TheMealDB (free) + Spoonacular (free tier)

## Project Structure
```
BellaRecipeRecommender/
├── App/
│   ├── BellaRecipeRecommenderApp.swift
│   └── AppDelegate.swift
├── Models/
│   ├── Recipe.swift
│   ├── Ingredient.swift
│   └── NutritionInfo.swift
├── Services/
│   ├── RecipeService.swift
│   ├── NetworkManager.swift
│   └── APIConstants.swift
├── ViewModels/
│   ├── RecipeListViewModel.swift
│   └── RecipeDetailViewModel.swift
├── Views/
│   ├── HomeView.swift
│   ├── IngredientInputView.swift
│   ├── RecipeListView.swift
│   ├── RecipeDetailView.swift
│   └── FilterView.swift
├── Utilities/
│   ├── Extensions.swift
│   └── Constants.swift
└── Resources/
    └── Assets.xcassets
```

## Installation
1. Clone the repository
2. Open `BellaRecipeRecommender.xcodeproj` in Xcode
3. Update API keys in `APIConstants.swift`
4. Build and run on simulator or device

## API Integration
- **TheMealDB**: Free API for meal/recipe data
- **Spoonacular**: Free tier for nutrition information

## Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Future Enhancements
- User authentication
- Saved favorite recipes
- Shopping list generation
- Recipe history
- Social sharing
- Offline mode

## License
MIT License
