//
//  IngredientListView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation

import SwiftUI

struct IngredientListView: View {
    private static let descriptor = NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)
    @FetchRequest(
        sortDescriptors: [Self.descriptor],
        animation: .default
    )
    private var ingredients: FetchedResults<Ingredient>
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isPresentingAddIngredientView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ingredients) { ingredient in
                    Text(ingredient.name ?? "Unknown Ingredient")
                }
                .onDelete(perform: deleteIngredients)
            }
            .navigationTitle("食材リスト")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingAddIngredientView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddIngredientView) {
                AddIngredientView()
            }
        }
    }
    
    private func deleteIngredients(offsets: IndexSet) {
        offsets.forEach { index in
            let ingredient = ingredients[index]
            viewContext.delete(ingredient)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting ingredient: \(error)")
        }
    }
}

struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientListView()
    }
}
