import React, { useState } from 'react';
import './RecipeDetailView.css';

function RecipeDetailView({ recipe, onBack }) {
  const [isFavorite, setIsFavorite] = useState(false);

  return (
    <div className="recipe-detail-view">
      {/* Header */}
      <div className="detail-header">
        <button className="btn-back" onClick={onBack}>←</button>
        <button
          className="btn-favorite"
          onClick={() => setIsFavorite(!isFavorite)}
        >
          {isFavorite ? '❤️' : '🤍'}
        </button>
      </div>

      {/* Scrollable Content */}
      <div className="detail-scroll">
        {/* Image */}
        <div className="detail-image">
          <img
            src={recipe.image}
            alt={recipe.name}
            onError={(e) => {
              e.target.src = 'https://via.placeholder.com/400x300?text=Recipe';
            }}
          />
        </div>

        {/* Content */}
        <div className="detail-content">
          {/* Title */}
          <div className="detail-title-section">
            <h1 className="detail-title">{recipe.name}</h1>
            <p className="detail-source">{recipe.source}</p>
          </div>

          {/* Stats */}
          <div className="detail-stats">
            <div className="stat-box">
              <div className="stat-value" style={{ color: '#F97316' }}>
                {Math.round(recipe.matchPercentage)}%
              </div>
              <div className="stat-label">Match</div>
            </div>

            <div className="stat-box">
              <div className="stat-value">{recipe.difficulty}</div>
              <div className="stat-label">Difficulty</div>
            </div>

            {recipe.servings && (
              <div className="stat-box">
                <div className="stat-value">{recipe.servings}</div>
                <div className="stat-label">Servings</div>
              </div>
            )}
          </div>

          {/* Ingredients */}
          <section className="detail-section">
            <h2>Ingredients</h2>
            <ul className="ingredients-list">
              {recipe.ingredients.map((ingredient, index) => (
                <li key={index} className="ingredient-item">
                  <span className="ingredient-icon">●</span>
                  {ingredient}
                </li>
              ))}
            </ul>
          </section>

          {/* Instructions */}
          {recipe.instructions && (
            <section className="detail-section">
              <h2>Instructions</h2>
              <p className="instructions-text">{recipe.instructions}</p>
            </section>
          )}

          {/* View Recipe Button */}
          <a
            href={recipe.url}
            target="_blank"
            rel="noopener noreferrer"
            className="btn-view-recipe"
          >
            View Full Recipe →
          </a>
        </div>
      </div>
    </div>
  );
}

export default RecipeDetailView;
