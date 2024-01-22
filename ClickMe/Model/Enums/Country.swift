//
//  Country.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation

enum Country: String, Codable, Identifiable, Hashable {
    case canada
    case usa
    case other
    
    var id: Country { self }
    
    func text() -> String {
        switch self {
        case .canada:
            return "Canada"
        case .usa:
            return "USA"
        case .other:
            return "Other"
        }
    }
    
    func stripeValue() -> String {
        switch self {
        case .canada:
            return "CA"
        case .usa:
            return "USA"
        case .other:
            fatalError()
        }
    }
    
    static func list() -> [Country] {
        return [.canada, .usa, .other]
    }
}

extension Country {
    init(from decoder: Decoder) throws {
        self = try Country(rawValue: decoder.singleValueContainer().decode(RawValue.self).lowercased()) ?? .other
    }
}
