//
//  AddIngredientView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import SwiftUI

struct AddIngredientView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @State private var ingredientName = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("食材名")) {
                    TextField("食材名を入力してください", text: $ingredientName)
                }
            }
            .navigationTitle("食材追加")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveIngredient()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(ingredientName.isEmpty)
                }
            }
        }
    }

    private func saveIngredient() {
        let newIngredient = Ingredient(context: viewContext)
        newIngredient.name = ingredientName

        do {
            try viewContext.save()
        } catch {
            print("Error saving ingredient: \(error)")
        }
    }
}

struct AddIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientView()
    }
}
