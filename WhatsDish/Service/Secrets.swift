//
//  Secrets.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation

struct Secrets {
    private static let secrets: NSDictionary = {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            return dict
        } else {
            fatalError("Couldn't load Secrets.plist")
        }
    }()
    
    static let apiKey: String = {
        guard let apiKey = secrets["API_KEY"] as? String else {
            fatalError("Couldn't find API_KEY in Secrets.plist")
        }
        return apiKey
    }()
}
