//
//  Recipe.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation

struct Recipe: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let detail: String?
}
