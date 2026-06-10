import React, { useState } from 'react';
import './App.css';
import RecipeService from './services/RecipeService';
import ContentView from './views/ContentView';
import IngredientInputView from './views/IngredientInputView';
import RecipeListView from './views/RecipeListView';

function App() {
  const [recipes, setRecipes] = useState([]);
  const [filteredRecipes, setFilteredRecipes] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState(null);
  const [selectedIngredients, setSelectedIngredients] = useState([]);
  const [selectedDietaryRestrictions, setSelectedDietaryRestrictions] = useState([]);
  const [searchText, setSearchText] = useState('');
  const [showIngredientInput, setShowIngredientInput] = useState(false);
  const [view, setView] = useState('home'); // 'home' or 'recipes'

  const searchRecipes = async (ingredients) => {
    setIsLoading(true);
    setErrorMessage(null);

    try {
      const foundRecipes = await RecipeService.searchRecipesByMultipleIngredients(ingredients);
      
      // Calculate matched ingredients
      const recipesDotted = foundRecipes.map(recipe => {
        const matchedCount = recipe.ingredients.filter(ingredient =>
          ingredients.some(selectedIng =>
            ingredient.toLowerCase().includes(selectedIng.toLowerCase()) ||
            selectedIng.toLowerCase().includes(ingredient.toLowerCase())
          )
        ).length;
        return {
          ...recipe,
          matchedIngredients: matchedCount,
          matchPercentage: (matchedCount / recipe.totalIngredients) * 100
        };
      }).sort((a, b) => b.matchPercentage - a.matchPercentage);

      setRecipes(recipesDotted);
      setFilteredRecipes(recipesDotted);
      setView('recipes');
    } catch (error) {
      setErrorMessage(error.message);
    }

    setIsLoading(false);
  };

  const handleSearch = async (ingredients) => {
    setSelectedIngredients(ingredients);
    await searchRecipes(ingredients);
    setShowIngredientInput(false);
  };

  const addDietaryRestriction = (restriction) => {
    if (!selectedDietaryRestrictions.includes(restriction)) {
      const newRestrictions = [...selectedDietaryRestrictions, restriction];
      setSelectedDietaryRestrictions(newRestrictions);
      applyFilters(searchText, newRestrictions);
    }
  };

  const removeDietaryRestriction = (restriction) => {
    const newRestrictions = selectedDietaryRestrictions.filter(r => r !== restriction);
    setSelectedDietaryRestrictions(newRestrictions);
    applyFilters(searchText, newRestrictions);
  };

  const applyFilters = (search, restrictions = selectedDietaryRestrictions) => {
    let filtered = recipes;

    // Filter by dietary restrictions
    if (restrictions.length > 0) {
      filtered = RecipeService.filterRecipesByDietaryRestrictions(filtered, restrictions);
    }

    // Filter by search text
    if (search.trim()) {
      filtered = filtered.filter(recipe =>
        recipe.name.toLowerCase().includes(search.toLowerCase()) ||
        recipe.ingredients.some(ing => ing.toLowerCase().includes(search.toLowerCase()))
      );
    }

    setFilteredRecipes(filtered);
  };

  const handleSearchTextChange = (text) => {
    setSearchText(text);
    applyFilters(text);
  };

  const clearAll = () => {
    setRecipes([]);
    setFilteredRecipes([]);
    setSelectedIngredients([]);
    setSelectedDietaryRestrictions([]);
    setSearchText('');
    setErrorMessage(null);
    setView('home');
  };

  return (
    <div className="app">
      {view === 'home' ? (
        <ContentView
          recipes={recipes}
          showIngredientInput={showIngredientInput}
          onAddIngredientsClick={() => setShowIngredientInput(true)}
          onCloseInput={() => setShowIngredientInput(false)}
          onSearch={handleSearch}
          isLoading={isLoading}
        />
      ) : (
        <RecipeListView
          recipes={filteredRecipes}
          selectedDietaryRestrictions={selectedDietaryRestrictions}
          onAddDietaryRestriction={addDietaryRestriction}
          onRemoveDietaryRestriction={removeDietaryRestriction}
          searchText={searchText}
          onSearchTextChange={handleSearchTextChange}
          isLoading={isLoading}
          onBackClick={() => clearAll()}
        />
      )}
    </div>
  );
}

export default App;
