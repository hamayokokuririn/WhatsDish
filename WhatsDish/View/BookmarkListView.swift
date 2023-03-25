//
//  BookmarkListView.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import SwiftUI
import CoreData

struct BookmarkListView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    // FetchRequestを作成し、Bookmarkエンティティからデータを取得
    @FetchRequest(
        entity: Bookmark.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookmark.creationDate, ascending: true)]
    ) private var bookmarks: FetchedResults<Bookmark>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookmarks, id: \.self) { bookmark in
                    NavigationLink(destination: RecipeDetailView(recipe: bookmark.makeRecipe(), showBookmarkButton: false)) {
                        Text(bookmark.title ?? "")
                    }
                }
                .onDelete(perform: deleteBookmark)
            }
            .navigationTitle("Bookmarks")
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func deleteBookmark(at offsets: IndexSet) {
        for index in offsets {
            let bookmark = bookmarks[index]
            managedObjectContext.delete(bookmark)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error deleting bookmark: \(error)")
        }
    }
}

