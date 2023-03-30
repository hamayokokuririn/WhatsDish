//
//  RegularExpressionServiceTests.swift
//  WhatsDishTests
//
//  Created by 齋藤健悟 on 2023/03/24.
//

import Foundation
import XCTest
@testable import WhatsDish

class RegularExpressionServiceTests: XCTestCase {


    func testExtractJSONString() {
        let input = """
From GPT😀: 【提案料理】
[
  {
    "title": "ピリッと辛いエビチリ",
    "catchphrase": "辛さと旨味が口いっぱい広がる大人気の中華料理",
    "score": 4.5
  },
  {
    "title": "ふんわりとろけるチーズオムレツ",
    "catchphrase": "とろ～りチーズが絶妙なハーモニーを奏でるボリューミーな朝食",
    "score": 4.3
  }
]
"""
        let result = RegularExpressionService.extractJSONString(from: input)
        let expectedOutput = """
[
  {
    "title": "ピリッと辛いエビチリ",
    "catchphrase": "辛さと旨味が口いっぱい広がる大人気の中華料理",
    "score": 4.5
  },
  {
    "title": "ふんわりとろけるチーズオムレツ",
    "catchphrase": "とろ～りチーズが絶妙なハーモニーを奏でるボリューミーな朝食",
    "score": 4.3
  }
]
"""
        XCTAssertEqual(result, expectedOutput)
    }
    
}

