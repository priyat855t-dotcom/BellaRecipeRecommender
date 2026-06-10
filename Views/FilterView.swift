//
//  FilterView.swift
//  BellaRecipeRecommender
//
//  View for dietary restrictions filtering
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0.95, green: 0.93, blue: 0.88, alpha: 1)), Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.91, alpha: 1))]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text("Dietary Restrictions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(DietaryRestriction.allCases, id: \.self) { restriction in
                                HStack(spacing: 12) {
                                    Image(systemName: viewModel.selectedDietaryRestrictions.contains(restriction) ? "checkmark.square.fill" : "square")
                                        .font(.headline)
                                        .foregroundColor(viewModel.selectedDietaryRestrictions.contains(restriction) ? .orange : .gray)
                                    
                                    Text(restriction.emoji)
                                        .font(.title3)
                                    
                                    Text(restriction.rawValue)
                                        .font(.body)
                                    
                                    Spacer()
                                }
                                .padding(12)
                                .background(viewModel.selectedDietaryRestrictions.contains(restriction) ? Color.orange.opacity(0.1) : Color.white)
                                .cornerRadius(10)
                                .onTapGesture {
                                    if viewModel.selectedDietaryRestrictions.contains(restriction) {
                                        viewModel.removeDietaryRestriction(restriction)
                                    } else {
                                        viewModel.addDietaryRestriction(restriction)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            viewModel.selectedDietaryRestrictions.removeAll()
                            isPresented = false
                        }) {
                            Text("Clear All")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        }
                        
                        Button(action: { isPresented = false }) {
                            Text("Apply")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FilterView(viewModel: RecipeListViewModel(), isPresented: .constant(true))
}
