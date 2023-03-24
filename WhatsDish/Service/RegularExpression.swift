//
//  RegularExpression.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation

enum RegularExpressionService {
    static func extractRecipeTitles(from suggestionJSON: String) throws -> [Recipe] {
        if let data = suggestionJSON.data(using: .utf8) {
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            return recipes
        }
        return []
    }
}
