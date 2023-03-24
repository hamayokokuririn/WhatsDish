//
//  MenuSuggestionView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/23.
//

import SwiftUI

struct MealSuggestionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.date, ascending: true)],
        animation: .default
    )
    private var meals: FetchedResults<Meal>
    @FetchRequest(
        entity: Ingredient.entity(), sortDescriptors: []
    )
    private var ingredients: FetchedResults<Ingredient>
    
    @State private var mealSuggestion: String = ""
    @State private var isFetching: Bool = false
    @State private var selectedRecipe: Recipe?
    
    private let openAIService = OpenAIService()

    var body: some View {
        VStack {
            if isFetching {
                ProgressView("提案を取得中...")
            } else {
                Spacer()
                if mealSuggestion.isEmpty {
                    Text("食事提案がまだありません。")
                } else {
                    Text("今日の食事提案")
                    let recipeList = RegularExpressionService.extractRecipeTitles(from: mealSuggestion)
                    List {
                        ForEach(recipeList) { recipe in
                            Button(action: {
                                selectedRecipe = recipe
                            }) {
                                Text(recipe.title)
                            }
                        }
                    }
                    .sheet(item: $selectedRecipe) { recipe in
                        RecipeDetailView(recipe: recipe)
                    }
                }

                Spacer()
                Button("食事提案を取得") {
                    Task {
                        await fetchMealSuggestion()                        
                    }
                }
            }
        }
        .padding()
    }

    private func fetchMealSuggestion() async {
        isFetching = true
        do {
            let suggestion = try await openAIService.generateMealSuggestion(meals: Array(meals), ingredients: Array(ingredients))
            mealSuggestion = suggestion
        } catch {
            print("Error fetching meal suggestion: \(error)")
        }
        isFetching = false
    }
}

struct MealSuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        MealSuggestionView()
    }
}
