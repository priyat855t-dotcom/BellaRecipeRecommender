import React from 'react';
import './ContentView.css';
import IngredientInputView from './IngredientInputView';

function ContentView({ recipes, showIngredientInput, onAddIngredientsClick, onCloseInput, onSearch, isLoading }) {
  return (
    <div className="content-view">
      {/* Header */}
      <div className="header">
        <h1 className="title">🍳 Bella</h1>
        <p className="subtitle">Find recipes with ingredients you have</p>
      </div>

      {recipes.length === 0 ? (
        <div className="empty-state">
          <div className="empty-icon">🔍</div>
          <h2>No Recipes Yet</h2>
          <p>Enter your available ingredients to get personalized recipe recommendations</p>
          <button className="btn-primary" onClick={onAddIngredientsClick}>
            Add Ingredients
          </button>
        </div>
      ) : null}

      {/* Floating Action Button */}
      <button className="fab" onClick={onAddIngredientsClick}>
        +
      </button>

      {/* Ingredient Input Modal */}
      {showIngredientInput && (
        <IngredientInputView
          onClose={onCloseInput}
          onSearch={onSearch}
          isLoading={isLoading}
        />
      )}
    </div>
  );
}

export default ContentView;
