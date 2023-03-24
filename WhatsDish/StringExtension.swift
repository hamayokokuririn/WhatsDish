//
//  StringExtension.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation

extension String {
    func getAttributedString() -> AttributedString {
        do {
            let attributedString = try AttributedString(markdown: self)
            return attributedString
        } catch {
            print("Couldn't parse: \(error)")
        }
        return AttributedString("Error parsing markdown")
    }
}
