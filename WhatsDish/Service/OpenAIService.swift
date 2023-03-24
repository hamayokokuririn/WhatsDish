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

    func generateMealSuggestion(meals: [Meal], ingredients: [Ingredient]) async throws -> String {
        let messages = createMessages(meals: meals, ingrediens: ingredients)
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
        return try parseResponse(data: data)
    }
    
    private func createMessages(meals: [Meal], ingrediens: [Ingredient]) -> [[String: String]] {
        let mealsDescription = makeMealsDescription(meals: meals)
        let ingredientsDescription = makeIngredientsDescription(ingredients: ingrediens)
        let userMessage: [String: String] = [
            "role": "user",
            "content": """
以下の食事履歴があります: \(mealsDescription)。これらとは異なるおすすめの料理を提案してください。
また提案の際には、次の食材を使用するレシピになるように考慮してください。食材はこちらです：\(ingredientsDescription)
出力はハイフンから始まる箇条書きで、料理名のみ含めるようにお願いします。
"""
        ]
        
        let systemMessage: [String: String] = [
            "role": "system",
            "content": "あなたは一流の料理研究家です。人気のある料理を積極的に提案します。また、忙しい家事の合間に作れるような作りやすい食事の提案をします。"
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
            "content": "あなたは一流の料理研究家です。初心者にもわかりやすく料理を説明します。\(recipe.title)のレシピを教えてください。まず必要な材料を示し、次に手順を箇条書きで具体的にお願いします。"
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

