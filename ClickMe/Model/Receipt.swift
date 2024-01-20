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
    let stripeCustomerId: String?
    let paymentIntentId: String?
    let paymentIntentClientKey: String?
    let requestId: String
    let status: ReceiptStatus
    let amount: Double
    let currency: Currency
    var request: Request?
    var topic: Topic?
    var bookingUser: UserProfile?
    var host: UserProfile?
    var statusChangeDate: Date
    var amountPaidOut: Int
    var commission: Int
    
    var statusChangeDateDisplayable: String {
        return DateUtil.convert(input: statusChangeDate, outputFormat: .format11)!
    }
    
    var amountDisplayable: String {
        if amount == 0 {
            return "FREE"
        }
        let dollarAmount: Double = Double(amount) / 100.0
        return "$\(String(format: "%.2f", dollarAmount)) \(currency.text())"
    }
    
    var amountPaidOutDisplayable: String {
        if amountPaidOut == 0 {
            return "--"
        }
        let dollarAmount: Double = Double(amountPaidOut) / 100.0
        return "$\(String(format: "%.2f", dollarAmount)) \(currency.text())"
    }
    
    var commissionDisplayable: String {
        if commission == 0 {
            return "--"
        }
        let dollarAmount: Double = Double(commission) / 100.0
        return "$\(String(format: "%.2f", dollarAmount)) \(currency.text())"
    }
    
    static func == (lhs: Receipt, rhs: Receipt) -> Bool {
        return lhs._id == rhs._id && lhs.status == rhs.status
    }
}
