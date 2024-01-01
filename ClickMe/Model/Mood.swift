//
//  Mood.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import UIKit

enum Mood: String, Codable {
    case startup
    case career
    case advance
    case welfare
    case pressure
    case advice
    case lifestyle
    case society
    case unknown
    
    func icon() -> UIImage {
        switch self {
        case .startup:
            return UIImage(named: "mood_startup")!
        case .career:
            return UIImage(named: "mood_career")!
        case .advance:
            return UIImage(named: "mood_advance")!
        case .welfare:
            return UIImage(named: "mood_welfare")!
        case .pressure:
            return UIImage(named: "mood_pressure")!
        case .advice:
            return UIImage(named: "mood_advice")!
        case .lifestyle:
            return UIImage(named: "mood_lifestyle")!
        case .society:
            return UIImage(named: "mood_social")!
        case .unknown:
            return UIImage(named: "field_other")!
        }
    }
    
    static func list() -> [Mood] {
        return [.startup, .career, .advance, .welfare, .pressure, .advice, .lifestyle, .society]
    }
}

extension Mood {
    init(from decoder: Decoder) throws {
        self = try Mood(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
