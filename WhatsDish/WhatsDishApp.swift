//
//  WhatsDishApp.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/23.
//

import SwiftUI
import CoreData

@main
struct WhatsDishApp: App {
    @StateObject private var coreDataController = CoreDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}
