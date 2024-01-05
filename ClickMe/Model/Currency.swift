//
//  Currency.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation

enum Currency: String, Codable, Identifiable {
    case USD
    case CAD
    
    var id: Currency { self }
    
    func text() -> String {
        switch self {
        case .USD:
            return "USD"
        case .CAD:
            return "CAD"
        }
    }
    
    static func list() -> [Currency] {
        return [.USD, .CAD]
    }
}

extension Currency {
    init(from decoder: Decoder) throws {
        self = try Currency(rawValue: decoder.singleValueContainer().decode(RawValue.self).lowercased()) ?? .USD
    }
}
