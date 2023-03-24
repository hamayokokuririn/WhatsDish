//
//  CoreDataController.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/23.
//

import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "WhatsDish")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Dataの読み込みに失敗しました: \(error)")
            }
        }
    }
}

