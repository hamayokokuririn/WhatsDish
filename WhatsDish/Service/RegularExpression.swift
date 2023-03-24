//
//  RegularExpression.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation

enum RegularExpressionService {
    static func extractRecipeTitles(from suggestion: String) -> [Recipe] {

        let pattern = "^-\\s([^\\n]+)"

        let regex: NSRegularExpression
        
        do {
            regex = try NSRegularExpression(pattern: pattern,
                                            options: .anchorsMatchLines)
        } catch {
            print("Invalid regular expression pattern")
                    return []
        }
        
        let matches = regex.matches(in: suggestion, range: NSRange(location: 0, length: suggestion.utf16.count))
        var recipeTitles: [String] = []
        
        for match in matches {
            if let range = Range(match.range(at: 1), in: suggestion) {
                let recipeTitle = String(suggestion[range])
                recipeTitles.append(recipeTitle)
            }
        }
        return recipeTitles.map {
            Recipe(title: $0, detail: nil)
        }
    }
}
