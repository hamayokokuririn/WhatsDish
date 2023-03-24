//
//  Recipe.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation

class Recipe: Identifiable, Equatable, Decodable {
    
    init(title: String, detail: String? = nil, catchphrase: String, score: Double) {
        self.title = title
        self.detail = detail
        self.catchphrase = catchphrase
        self.score = score
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.title == rhs.title
    }
    
    var id = UUID()
    let title: String
    let detail: String?
    let catchphrase: String
    let score: Double
    
}
