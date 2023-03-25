//
//  Recipe.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation

struct Recipe: Identifiable, Equatable, Decodable {
    
    init(title: String, detail: String? = nil, catchphrase: String, score: Double) {
        self.id = UUID()
        self.title = title
        self.detail = detail
        self.catchphrase = catchphrase
        self.score = score
    }
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case detail
        case catchphrase
        case score
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.title = try container.decode(String.self, forKey: .title)
        self.detail = nil
        self.catchphrase = try container.decode(String.self, forKey: .catchphrase)
        self.score = try container.decode(Double.self, forKey: .score)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.title == rhs.title
    }
    
    let id: UUID
    let title: String
    let detail: String?
    let catchphrase: String
    let score: Double
    
}

extension Bookmark {
    func makeRecipe() -> Recipe {
        return Recipe(title: self.title!,
                      detail: self.recipe!,
                      catchphrase: self.catchphrase!,
                      score: 0)
    }
}
