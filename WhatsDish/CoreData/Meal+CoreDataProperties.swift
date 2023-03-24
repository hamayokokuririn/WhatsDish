//
//  Meal+CoreDataProperties.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/23.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var date: Date?

}

extension Meal : Identifiable {

}
