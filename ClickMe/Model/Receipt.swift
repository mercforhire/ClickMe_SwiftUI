//
//  Receipt.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import Foundation

struct Receipt: Codable, Identifiable, Hashable {
    var id: String { return _id }
    
    let _id: String
    let createdDate: Date
    let paymentIntentId: String?
    let paymentIntentClientKey: String?
    let requestId: String
    let status: ReceiptStatus
    let amount: Double
    let currency: Currency
    var request: Request?
    var topic: Topic?
    var bookingUser: UserProfile?
    
    var displayablePrice: String {
        if amount == 0 {
            return "FREE"
        }
        let dollarAmount: Double = Double(amount) / 100.0
        return "$\(String(format: "%.2f", dollarAmount)) \(currency.text())"
    }
    
    static func == (lhs: Receipt, rhs: Receipt) -> Bool {
        return lhs._id == rhs._id && lhs.status == rhs.status
    }
}
