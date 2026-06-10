//
//  RecipeListView.swift
//  BellaRecipeRecommender
//
//  View for displaying recipe list
//

import SwiftUI

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    @State private var showFilters = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Filter Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search recipes...", text: $viewModel.searchText)
                    .onChange(of: viewModel.searchText) { _, _ in
                        viewModel.applyFilters()
                    }
                
                Button(action: { showFilters = true }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.orange)
                }
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            .padding(16)
            
            if !viewModel.selectedDietaryRestrictions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.selectedDietaryRestrictions, id: \.self) { restriction in
                            HStack(spacing: 6) {
                                Text(restriction.emoji)
                                Text(restriction.rawValue)
                                    .font(.caption)
                                
                                Button(action: { viewModel.removeDietaryRestriction(restriction) }) {
                                    Image(systemName: "xmark")
                                        .font(.caption2)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            // Recipe List
            ScrollView {
                LazyVStack(spacing: 12) {
                    if viewModel.filteredRecipes.isEmpty && !viewModel.recipes.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No recipes match your filters")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(40)
                    } else {
                        ForEach(viewModel.filteredRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipeCardView(recipe: recipe)
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .sheet(isPresented: $showFilters) {
            FilterView(viewModel: viewModel, isPresented: $showFilters)
        }
    }
}

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            AsyncImage(url: URL(string: recipe.image)) { phase in
                switch phase {
                case .empty:
                    SkeletonView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.gray.opacity(0.3)
                @unknown default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(height: 180)
            .clipped()
            .cornerRadius(10)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(recipe.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(recipe.matchPercentage))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .cornerRadius(4)
                        
                        Text("Match")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                // Info Row
                HStack(spacing: 12) {
                    Label(recipe.difficulty.rawValue, systemImage: "chart.bar")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Label(recipe.source, systemImage: "map")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Ingredients preview
                Text(recipe.ingredients.prefix(3).joined(separator: ", ") + (recipe.ingredients.count > 3 ? "..." : ""))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4, y: 2)
    }
}

struct SkeletonView: View {
    var body: some View {
        Color.gray.opacity(0.3)
            .shimmer()
    }
}

extension View {
    func shimmer() -> some View {
        self.redacted(reason: .placeholder)
    }
}

#Preview {
    RecipeListView(viewModel: RecipeListViewModel())
}
