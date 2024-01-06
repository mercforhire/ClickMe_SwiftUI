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
        let amount: Double = Double(priceHour) / 100.0
        return "\(amount.formatted(.currency(code: currency.rawValue))) / hour"
    }
    
    static func mockTopic() -> Topic {
        return Topic(_id: "6597179f748b7b670290b52d", userId: "6597171ad4f4d7af9f97da76", title: "Thesis vere decretum animi iure vilitas. ", keywords: ["startup", "advice"], description: "Libero repudiandae cohibeo a caelestis. Expedita testimonium contego. Contigo degusto admiratio vilitas demergo comitatus ut apud facere annus.", maxTimeMinutes: 180, priceHour: 2000, currency: .USD, mood: .startup, userProfile: UserProfile.mockProfile())
    }
}
