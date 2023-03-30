//
//  OpenAIService.swift
//  WhatsDish
//
//  Created by 齋藤健悟 on 2023/03/23.
//

import Foundation

class OpenAIService {
    
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    
    enum OpenAIError: Error {
        case invalidURL
        case parsingError
    }

    func generateMealSuggestion(meals: [Meal], ingredients: [Ingredient], addMessage: String) async throws -> [Recipe] {
        let messages = createMessages(meals: meals, ingrediens: ingredients, addMessage: addMessage)
        let requestData = createRequestData(messages: messages)
        
        guard let url = URL(string: apiURL) else {
            throw OpenAIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        request.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try parseResponse(data: data)
        let jsonString = RegularExpressionService.extractJSONString(from: response)
        return try RegularExpressionService.extractRecipeTitles(from: jsonString)
        
    }
    
    private func createMessages(meals: [Meal], ingrediens: [Ingredient], addMessage: String) -> [[String: String]] {
        let mealsDescription = makeMealsDescription(meals: meals)
        let ingredientsDescription = makeIngredientsDescription(ingredients: ingrediens)
        let userMessage: [String: String] = [
            "role": "user",
            "content":
        """
        以下の食事履歴があります: \(mealsDescription)。これらとは異なるおすすめの料理を提案してください。
        また提案の際には、次の食材を使用するレシピになるように考慮してください。食材はこちらです：\(ingredientsDescription)
        また追加の要望はこちらです。\(addMessage)。
        必ずjson文字列のみでお願いします。json形式以外の文章は含めないでください。内容は、料理名(title)、料理したくなるようなキャッチフレーズ(catchphrase)、おすすめ度(score)を五段階で何点かです。５つまでjson形式の配列で示してください。以下に例を示します。
        [
          {
            "name": "タコライス",
            "catchphrase": "沖縄の風を感じるエキゾチックな和洋折衷料理",
            "score": 4.2
          }
        ]
        """
        ]
        
        let systemMessage: [String: String] = [
            "role": "system",
            "content": "あなたは一流の料理研究家の情報をもつAPIサーバーです。人気のある料理を積極的に提案します。また、なかなか思いつかない料理を提案します。返答には、APIサーバーが返却するように、json文字列のみを返してください。"
        ]
        
        return [systemMessage, userMessage]
    }
    
    private func makeMealsDescription(meals: [Meal]) -> String {
        return meals
            .compactMap { meal -> String? in
                if let name = meal.name, let mealDescription = meal.mealDescription {
                    return "\(name) (\(mealDescription))"
                } else {
                    return nil
                }
            }
            .joined(separator: ", ")
    }
    
    private func makeIngredientsDescription(ingredients: [Ingredient]) -> String {
        return ingredients.map { $0.name ?? "" }
            .joined(separator: ", ")
    }

    private func createRequestData(messages: [[String: String]]) -> Data {
        let requestData: [String: Any] = [
            "messages": messages,
            "max_tokens": 500,
            "model": "gpt-3.5-turbo"
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: requestData, options: [])
        return jsonData
    }
    
    private func parseResponse(data: Data) throws -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: String],
              let content = message["content"] else {
            throw OpenAIError.parsingError
        }
        print("From GPT😀: \(content)")
        
        return content.trimmingCharacters(in: .whitespaces)
    }
    
    func fetchRecipe(for recipe: Recipe) async throws -> String {
        let message: [String: String] = [
            "role": "user",
            "content": "あなたは一流の料理研究家です。初心者にもわかりやすく料理を説明します。\(recipe.title)のレシピを教えてください。キャッチフレーズは\(recipe.catchphrase)です。まず必要な材料を示し、次に手順を箇条書きで具体的にお願いします。"
        ]
        let requestData = createRequestData(messages: [message])
        guard let url = URL(string: apiURL) else {
            throw OpenAIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        request.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try parseResponse(data: data)
    }

}

