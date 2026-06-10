import React, { useState } from 'react';
import './RecipeListView.css';
import RecipeCardView from '../components/RecipeCardView';
import RecipeDetailView from '../components/RecipeDetailView';

const DIETARY_RESTRICTIONS = [
  'Vegan', 'Vegetarian', 'Gluten-Free', 'Dairy-Free',
  'Keto', 'Paleo', 'Low-Carb', 'High-Protein'
];

const DIETARY_EMOJIS = {
  'Vegan': '🌱',
  'Vegetarian': '🥬',
  'Gluten-Free': '🌾',
  'Dairy-Free': '🥛',
  'Keto': '🥩',
  'Paleo': '🍖',
  'Low-Carb': '📉',
  'High-Protein': '💪'
};

function RecipeListView({
  recipes,
  selectedDietaryRestrictions,
  onAddDietaryRestriction,
  onRemoveDietaryRestriction,
  searchText,
  onSearchTextChange,
  isLoading,
  onBackClick
}) {
  const [showFilters, setShowFilters] = useState(false);
  const [selectedRecipe, setSelectedRecipe] = useState(null);

  if (selectedRecipe) {
    return (
      <RecipeDetailView
        recipe={selectedRecipe}
        onBack={() => setSelectedRecipe(null)}
      />
    );
  }

  return (
    <div className="recipe-list-view">
      {/* Header */}
      <div className="list-header">
        <button className="btn-back" onClick={onBackClick}>←</button>
        <h1>Recipes</h1>
        <div style={{ width: '40px' }}></div>
      </div>

      {/* Search and Filter Bar */}
      <div className="search-filter-bar">
        <div className="search-box">
          <span className="search-icon">🔍</span>
          <input
            type="search"
            placeholder="Search recipes..."
            value={searchText}
            onChange={(e) => onSearchTextChange(e.target.value)}
          />
        </div>
        <button
          className="filter-btn"
          onClick={() => setShowFilters(!showFilters)}
        >
          ⚙️
        </button>
      </div>

      {/* Active Filters */}
      {selectedDietaryRestrictions.length > 0 && (
        <div className="active-filters">
          {selectedDietaryRestrictions.map((restriction) => (
            <div key={restriction} className="filter-chip">
              <span>{DIETARY_EMOJIS[restriction]} {restriction}</span>
              <button
                className="chip-close"
                onClick={() => onRemoveDietaryRestriction(restriction)}
              >
                ✕
              </button>
            </div>
          ))}
        </div>
      )}

      {/* Filters Modal */}
      {showFilters && (
        <div className="filters-modal">
          <div className="filters-content">
            <h3>Dietary Restrictions</h3>
            <div className="filters-list">
              {DIETARY_RESTRICTIONS.map((restriction) => (
                <label key={restriction} className="filter-option">
                  <input
                    type="checkbox"
                    checked={selectedDietaryRestrictions.includes(restriction)}
                    onChange={(e) => {
                      if (e.target.checked) {
                        onAddDietaryRestriction(restriction);
                      } else {
                        onRemoveDietaryRestriction(restriction);
                      }
                    }}
                  />
                  <span>{DIETARY_EMOJIS[restriction]} {restriction}</span>
                </label>
              ))}
            </div>
            <button
              className="btn-primary"
              onClick={() => setShowFilters(false)}
              style={{ width: '100%' }}
            >
              Done
            </button>
          </div>
        </div>
      )}

      {/* Recipe List */}
      <div className="recipes-container">
        {recipes.length === 0 ? (
          <div className="no-results">
            <div className="no-results-icon">🔍</div>
            <p>No recipes match your filters</p>
          </div>
        ) : (
          <div className="recipes-grid">
            {recipes.map((recipe) => (
              <div
                key={recipe.id}
                onClick={() => setSelectedRecipe(recipe)}
                style={{ cursor: 'pointer' }}
              >
                <RecipeCardView recipe={recipe} />
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default RecipeListView;
