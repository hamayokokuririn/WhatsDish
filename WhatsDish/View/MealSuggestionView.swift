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
    
    @State private var suggestedRecipes: [Recipe] = []
    @State private var isFetching: Bool = false
    @State private var selectedRecipe: Recipe?
    @State private var addText: String = ""
    
    private let openAIService = OpenAIService()
    
    init(mealSuggestion: [Recipe] = []) {
        _suggestedRecipes = State(initialValue: mealSuggestion)
    }

    var body: some View {
        VStack {
            if isFetching {
                ProgressView("提案を取得中...")
            } else {
                Spacer()
                if suggestedRecipes.isEmpty {
                    Spacer()
                    Text("食事リストで食べたことのない料理を提案します。")
                    Text("食材リストで作れる料理を提案します。")
                } else {
                    Text("今日の食事提案")
                    RecipeListView(suggestedRecipes: $suggestedRecipes)
                }

                Spacer()
                Form {
                    Text("追加の要望を入力できます")
                    TextField("要望", text: $addText)
                }
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
            suggestedRecipes = try await openAIService.generateMealSuggestion(meals: Array(meals), ingredients: Array(ingredients), addMessage: addText)
        } catch {
            print("Error fetching meal suggestion: \(error)")
        }
        isFetching = false
    }
}

struct MealSuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MealSuggestionView(mealSuggestion: [Recipe(title: "カレー",
                                                       catchphrase: "みんな大好き",
                                                       score: 3.0)])
            MealSuggestionView(mealSuggestion: [])
        }
    }
}
