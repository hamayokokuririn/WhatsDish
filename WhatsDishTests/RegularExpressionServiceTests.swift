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
    func testExtractRecipeTitles() {
        // テスト用の入力文字列
        let input = """
        今日の食事提案は以下のとおりです:
        - マルゲリータピザ
        - 鶏肉のカレー
        - シーザーサラダ
        """

        // 期待する結果
        let expected = ["マルゲリータピザ", "鶏肉のカレー", "シーザーサラダ"]

        // テスト対象の関数を呼び出し、結果を取得
        let result = RegularExpressionService.extractRecipeTitles(from: input)

        // 結果が期待通りであることを確認
        XCTAssertEqual(result, expected)
    }
    
    func testExtractRecipeTitlesEmptyString() {
        let input = ""
        let expectedOutput: [String] = []
        XCTAssertEqual(RegularExpressionService.extractRecipeTitles(from: input), expectedOutput)
    }
    
    func testExtractRecipeTitlesWithoutHyphen() {
        let input = "マルゲリータピザ\n鶏肉のカレー\nシーザーサラダ"
        let expectedOutput: [String] = []
        XCTAssertEqual(RegularExpressionService.extractRecipeTitles(from: input), expectedOutput)
    }
    
    func testExtractRecipeTitlesWithRandomText() {
        let input = "ランダムなテキストがここにある - ピザ\n次に何が来るかわからない - カレー\n完全に無作為 - サラダ"
        let expectedOutput: [String] = []
        XCTAssertEqual(RegularExpressionService.extractRecipeTitles(from: input), expectedOutput)
    }

    
}

