//
//  RegularExpression.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation
import RegexBuilder

enum RegularExpressionService {
    static func extractRecipeTitles(from suggestionJSON: String) throws -> [Recipe] {
        if let data = suggestionJSON.data(using: .utf8) {
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            return recipes
        }
        return []
    }
    
    static func extractJSONString(from text: String) -> String {
        let pattern = "\\[[^\\]]*\\]"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        let match = regex.firstMatch(in: text, options: [], range: range)
        if let matchRange = match?.range {
            let jsonSubstring = text[Range(matchRange, in: text)!]
            print(jsonSubstring)
            return String(jsonSubstring)
        }
        return ""
    }
}
