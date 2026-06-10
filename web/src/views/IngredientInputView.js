import React, { useState } from 'react';
import './IngredientInputView.css';

function IngredientInputView({ onClose, onSearch, isLoading }) {
  const [ingredientInput, setIngredientInput] = useState('');
  const [selectedIngredients, setSelectedIngredients] = useState([]);

  const handleAddIngredient = () => {
    const cleaned = ingredientInput.trim().toLowerCase();
    if (cleaned && !selectedIngredients.includes(cleaned)) {
      setSelectedIngredients([...selectedIngredients, cleaned]);
      setIngredientInput('');
    }
  };

  const handleRemoveIngredient = (ingredient) => {
    setSelectedIngredients(selectedIngredients.filter(ing => ing !== ingredient));
  };

  const handleSearch = () => {
    if (selectedIngredients.length > 0) {
      onSearch(selectedIngredients);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      handleAddIngredient();
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2>Add Ingredients</h2>
          <p>Enter ingredients you have at home</p>
        </div>

        {/* Input Field */}
        <div className="input-group">
          <input
            type="text"
            placeholder="Enter ingredient..."
            value={ingredientInput}
            onChange={(e) => setIngredientInput(e.target.value)}
            onKeyPress={handleKeyPress}
            autoFocus
          />
          <button
            className="btn-add"
            onClick={handleAddIngredient}
            disabled={!ingredientInput.trim()}
          >
            +
          </button>
        </div>

        {/* Selected Ingredients */}
        {selectedIngredients.length > 0 && (
          <div className="ingredients-section">
            <h3>Selected Ingredients ({selectedIngredients.length})</h3>
            <div className="ingredients-list">
              {selectedIngredients.map((ingredient) => (
                <div key={ingredient} className="ingredient-tag">
                  <span>✓ {ingredient}</span>
                  <button
                    className="btn-remove"
                    onClick={() => handleRemoveIngredient(ingredient)}
                  >
                    ✕
                  </button>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Action Buttons */}
        <div className="modal-actions">
          <button className="btn-secondary" onClick={onClose}>
            Cancel
          </button>
          <button
            className="btn-primary"
            onClick={handleSearch}
            disabled={selectedIngredients.length === 0 || isLoading}
          >
            {isLoading ? <div className="spinner-small"></div> : 'Search Recipes'}
          </button>
        </div>
      </div>
    </div>
  );
}

export default IngredientInputView;
