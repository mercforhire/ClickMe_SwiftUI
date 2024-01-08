//
//  Topic.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation

struct Topic: Codable, Identifiable {
    var id: String { return _id }
    
    var _id: String
    var userId: String
    var title: String
    var keywords: [String] = []
    var description: String
    var maxTimeMinutes: Int
    var priceHour: Int
    var currency: Currency
    var mood: Mood
    var userProfile: UserProfile?
    
    var displayablePrice: String {
        if priceHour == 0 {
            return "FREE"
        }
        let amount: Double = Double(priceHour) / 100.0
        return "\(amount.formatted(.currency(code: currency.rawValue))) / hour"
    }
    
    
}
