//
//  Receipt.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import Foundation

struct Receipt: Codable, Identifiable {
    var id: String { return _id }
    
    let _id: String
    let createdDate: Date
    let paymentIntentId: String
    let booker: UserProfile?
    let host: UserProfile?
    var topic: Topic?
    let requestId: String
    let request: Request?
    let status: ReceiptStatus
    let amount: Double
    let currency: Currency
    
    var displayablePrice: String {
        if amount == 0 {
            return "FREE"
        }
        let amount: Double = Double(amount) / 100.0
        return "\(amount.formatted(.currency(code: currency.rawValue)))"
    }
}
