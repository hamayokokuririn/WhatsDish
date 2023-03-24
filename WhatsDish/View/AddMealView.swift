//
//  RecordMealView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/23.
//

import SwiftUI
import CoreData

struct AddMealView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var mealName: String = ""
    @State private var mealCategory: String = ""
    @State private var mealDate: Date = .init()
    @State private var mealDescription: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("名前")) {
                    TextField("名前を入力", text: $mealName)
                }
                Section(header: Text("カテゴリ")) {
                    TextField("カテゴリを入力", text: $mealCategory)
                }
                Section(header: Text("日付")) {
                    DatePicker("日付", selection: $mealDate, displayedComponents: .date)
                }
                Section(header: Text("説明")) {
                    TextField("説明を入力", text: $mealDescription)
                }
                Button("記録する") {
                    saveMeal()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("食事の記録")
            
        }
    }

    private func saveMeal() {
        let newMeal = Meal(context: viewContext)
        newMeal.name = mealName
        newMeal.category = mealCategory
        newMeal.date = mealDate
        newMeal.mealDescription = mealDescription

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

struct AddMealView_Preview: PreviewProvider {
    static var previews: some View {
        AddMealView()
    }
}
