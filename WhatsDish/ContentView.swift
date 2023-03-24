//
//  ContentView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        TabView {
            MealListView()
                .tabItem {
                    Label("食事リスト", systemImage: "tray.full")
                }
            IngredientListView()
                .tabItem {
                    Label("食材リスト", systemImage: "leaf")
                }
            MealSuggestionView()
                .tabItem {
                    Label("提案", systemImage: "lightbulb")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
