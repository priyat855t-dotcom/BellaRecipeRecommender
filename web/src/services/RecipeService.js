import axios from 'axios';

const THEMEALDB_API = 'https://www.themealdb.com/api/json/v1/1';

class RecipeService {
  static async searchRecipesByIngredient(ingredient) {
    try {
      const response = await axios.get(`${THEMEALDB_API}/filter.php?i=${ingredient}`);
      const meals = response.data.meals || [];
      
      // Fetch full details for each meal
      const detailedMeals = await Promise.all(
        meals.map(meal => this.getRecipeDetails(meal.idMeal))
      );
      
      return detailedMeals.filter(meal => meal !== null);
    } catch (error) {
      console.error('Error searching recipes:', error);
      throw error;
    }
  }

  static async getRecipeDetails(mealID) {
    try {
      const response = await axios.get(`${THEMEALDB_API}/lookup.php?i=${mealID}`);
      const meal = response.data.meals?.[0];
      
      if (!meal) return null;

      const ingredients = this.getIngredientsFromMeal(meal);
      
      return {
        id: meal.idMeal,
        name: meal.strMeal,
        image: meal.strMealThumb || '',
        source: meal.strArea || 'Unknown',
        url: meal.strSource || 'https://www.themealdb.com',
        ingredients: ingredients,
        instructions: meal.strInstructions || '',
        prepTime: null,
        cookTime: null,
        servings: null,
        difficulty: this.determineDifficulty(meal.strInstructions),
        tags: meal.strTags ? meal.strTags.split(',') : [],
        nutrition: null,
        matchedIngredients: 0,
        totalIngredients: ingredients.length
      };
    } catch (error) {
      console.error('Error getting recipe details:', error);
      return null;
    }
  }

  static getIngredientsFromMeal(meal) {
    const ingredients = [];
    for (let i = 1; i <= 20; i++) {
      const ingredient = meal[`strIngredient${i}`];
      if (ingredient && ingredient.trim()) {
        ingredients.push(ingredient.trim());
      }
    }
    return ingredients;
  }

  static determineDifficulty(instructions) {
    if (!instructions) return 'Medium';
    const wordCount = instructions.split(/\s+/).length;
    
    if (wordCount < 50) return 'Easy';
    if (wordCount < 150) return 'Medium';
    return 'Hard';
  }

  static async searchRecipesByMultipleIngredients(ingredients) {
    try {
      const allRecipes = [];
      const recipeIDs = new Set();
      
      for (const ingredient of ingredients) {
        try {
          const recipes = await this.searchRecipesByIngredient(ingredient);
          for (const recipe of recipes) {
            if (!recipeIDs.has(recipe.id)) {
              recipeIDs.add(recipe.id);
              allRecipes.push(recipe);
            }
          }
        } catch (error) {
          console.warn(`Error searching for ${ingredient}:`, error);
        }
      }
      
      return allRecipes;
    } catch (error) {
      console.error('Error searching multiple ingredients:', error);
      throw error;
    }
  }

  static filterRecipesByDietaryRestrictions(recipes, restrictions) {
    return recipes.filter(recipe =>
      restrictions.every(restriction =>
        this.matchesDietaryRestriction(recipe, restriction)
      )
    );
  }

  static matchesDietaryRestriction(recipe, restriction) {
    const ingredientsLower = recipe.ingredients.map(i => i.toLowerCase());
    const recipeLower = (recipe.name + (recipe.instructions || '')).toLowerCase();
    
    switch (restriction) {
      case 'Vegan':
        return !ingredientsLower.some(ing =>
          ing.includes('meat') || ing.includes('chicken') ||
          ing.includes('fish') || ing.includes('egg') ||
          ing.includes('milk') || ing.includes('cheese') ||
          ing.includes('butter') || ing.includes('cream')
        );
      case 'Vegetarian':
        return !ingredientsLower.some(ing =>
          ing.includes('meat') || ing.includes('chicken') ||
          ing.includes('fish') || ing.includes('beef')
        );
      case 'Gluten-Free':
        return !ingredientsLower.some(ing =>
          ing.includes('wheat') || ing.includes('flour') ||
          ing.includes('bread') || ing.includes('pasta')
        );
      case 'Dairy-Free':
        return !ingredientsLower.some(ing =>
          ing.includes('milk') || ing.includes('cheese') ||
          ing.includes('butter') || ing.includes('cream')
        );
      case 'Keto':
        return recipeLower.includes('keto') || !ingredientsLower.some(ing =>
          ing.includes('sugar') || ing.includes('rice') ||
          ing.includes('pasta') || ing.includes('bread')
        );
      case 'Paleo':
        return !ingredientsLower.some(ing =>
          ing.includes('dairy') || ing.includes('grain') ||
          ing.includes('legume') || ing.includes('processed')
        );
      case 'Low-Carb':
        return !ingredientsLower.some(ing =>
          ing.includes('rice') || ing.includes('pasta') ||
          ing.includes('bread') || ing.includes('potato')
        );
      case 'High-Protein':
        return ingredientsLower.some(ing =>
          ing.includes('chicken') || ing.includes('beef') ||
          ing.includes('fish') || ing.includes('egg') ||
          ing.includes('protein')
        );
      default:
        return true;
    }
  }
}

export default RecipeService;
