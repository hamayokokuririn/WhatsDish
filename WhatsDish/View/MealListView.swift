//
//  MealHistoryView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/23.
//

import SwiftUI
import CoreData

struct MealListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.date, ascending: true)],
        animation: .default)
    private var meals: FetchedResults<Meal>

    @State private var isPresentingAddMealView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(meals) { meal in
                    VStack(alignment: .leading) {
                        Text(meal.name ?? "Unknown")
                            .font(.headline)
                        Text(meal.category ?? "Unknown")
                            .font(.subheadline)
                        Text("\(meal.date ?? Date(), formatter: dateFormatter)")
                            .font(.footnote)
                    }
                }
                .onDelete(perform: deleteMeals)
            }
            .navigationBarTitle("食事リスト")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingAddMealView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddMealView) {
                AddMealView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteMeals(offsets: IndexSet) {
        withAnimation {
            offsets.map { meals[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct MealListView_Preview: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
