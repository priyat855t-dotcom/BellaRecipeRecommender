import React from 'react';
import './RecipeCardView.css';

function RecipeCardView({ recipe }) {
  return (
    <div className="recipe-card">
      {/* Image */}
      <div className="recipe-image">
        <img
          src={recipe.image}
          alt={recipe.name}
          onError={(e) => {
            e.target.src = 'https://via.placeholder.com/300x200?text=Recipe';
          }}
        />
      </div>

      {/* Content */}
      <div className="recipe-content">
        <div className="recipe-title-row">
          <h3 className="recipe-title">{recipe.name}</h3>
          <div className="match-badge">
            <div className="match-percentage">{Math.round(recipe.matchPercentage)}%</div>
            <div className="match-label">Match</div>
          </div>
        </div>

        {/* Info Row */}
        <div className="recipe-info">
          <span className="info-item">📊 {recipe.difficulty}</span>
          <span className="info-item">📍 {recipe.source}</span>
        </div>

        {/* Ingredients Preview */}
        <p className="ingredients-preview">
          {recipe.ingredients.slice(0, 3).join(', ')}
          {recipe.ingredients.length > 3 ? '...' : ''}
        </p>
      </div>
    </div>
  );
}

export default RecipeCardView;
