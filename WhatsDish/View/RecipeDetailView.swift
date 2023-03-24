//
//  RecipeDetailView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//
import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    let recipe: Recipe
    
    @State private var recipeDetail: String?
    let openAIService = OpenAIService()
    
    var body: some View {
        VStack {
            Text(recipe.title)
                .font(.title)
            Spacer()
            if let recipeDetail {
                ScrollView {
                    Text(recipeDetail)
                }
            } else {
                ProgressView("レシピを取得中...")
            }
            Spacer()
            Button("閉じる") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
        .onAppear {
            Task {
                do {
                    let text = try await openAIService.fetchRecipe(for: recipe)
                    self.recipeDetail = text
                    print(text)
                } catch {
                    print("fetch error")
                }
            }
        }
    }
}

struct RecipeDetailView_Preview: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Recipe(title: "カレー", catchphrase: "みんな大好き", score: 4.5))
    }
}

