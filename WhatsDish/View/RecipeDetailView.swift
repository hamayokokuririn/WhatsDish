//
//  RecipeDetailView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//
import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext

    let recipe: Recipe
    let showBookmarkButton: Bool

    
    @State private var recipeDetail: String?
    @State private var isBookmarkButtonActive = false
    
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
            if showBookmarkButton {
                Button("ブックマークに追加") {
                    addBookmark()
                }
                .disabled(!isBookmarkButtonActive)
                .padding(.bottom)
            }
            Button("閉じる") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
        .onAppear {
            if let detail = recipe.detail {
                self.recipeDetail = detail
                return
            }
            Task {
                do {
                    let text = try await openAIService.fetchRecipe(for: recipe)
                    self.recipeDetail = text
                    self.isBookmarkButtonActive = true
                } catch {
                    print("fetch error")
                }
            }
        }
    }
    
    private func addBookmark() {
        let newBookmark = Bookmark(context: managedObjectContext)
        newBookmark.title = recipe.title
        newBookmark.recipe = recipeDetail
        newBookmark.creationDate = Date()
        newBookmark.catchphrase = recipe.catchphrase
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error adding bookmark: \(error)")
        }
    }
}

struct RecipeDetailView_Preview: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Recipe(title: "カレー",
                                        detail: "detail text...",
                                        catchphrase: "みんな大好き",
                                        score: 4.5), showBookmarkButton: true)
    }
}

