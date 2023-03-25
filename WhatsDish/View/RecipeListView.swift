//
//  RecipeListView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import SwiftUI

struct RecipeListView: View {
    @Binding var suggestedRecipes: [Recipe]

    @State private var selectedRecipe: Recipe?

    var body: some View {
        NavigationView {
            List {
                ForEach(suggestedRecipes, id: \.title) { recipe in
                    Button(action: {
                        selectedRecipe = recipe
                    }) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(recipe.title)
                                .font(.headline)
                            Text(recipe.catchphrase)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("おすすめ度: \(recipe.score, specifier: "%.1f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("料理リスト")
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe, showBookmarkButton: true)
            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let suggestedRecipes: [Recipe] = [
            Recipe(title: "タコライス", catchphrase: "沖縄の風を感じるエキゾチックな和洋折衷料理", score: 4.2),
            Recipe(title: "シーフードパエリア", catchphrase: "豊かな海の恵みをたっぷり詰め込んだスペインの伝統料理", score: 4.4)
        ]

        RecipeListView(suggestedRecipes: .constant(suggestedRecipes))
    }
}

