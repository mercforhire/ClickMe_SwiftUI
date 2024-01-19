//
//  ReceiptStatus.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import Foundation

enum ReceiptStatus: String, Codable, Identifiable {
    case UNPAID
    case AUTHORIZED
    case CANCELLED
    case PAID
    case PAID_OUT
    case unknown
    
    var id: ReceiptStatus { self }
    
    func text() -> String {
        switch self {
        case .UNPAID:
            return "Unpaid"
        case .AUTHORIZED:
            return "Authorized"
        case .CANCELLED:
            return "Cancelled"
        case .PAID:
            return "Paid"
        case .PAID_OUT:
            return "Paid out"
        case .unknown:
            return "Unknown"
        }
    }
}

extension ReceiptStatus {
    init(from decoder: Decoder) throws {
        self = try ReceiptStatus(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

