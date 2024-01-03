//
//  Mood.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import UIKit

enum Mood: String, Codable, Identifiable {
    case startup
    case career
    case advance
    case welfare
    case pressure
    case advice
    case lifestyle
    case society
    case other
    
    var id: Mood { self }
    
    func text() -> String {
        switch self {
        case .startup:
            return "Start up"
        case .career:
            return "Career"
        case .advance:
            return "Advance"
        case .welfare:
            return "Welfare"
        case .pressure:
            return "Pressure"
        case .advice:
            return "Advice"
        case .lifestyle:
            return "Lifestyle"
        case .society:
            return "Society"
        case .other:
            return "Other"
        }
    }
    
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
        case .other:
            return UIImage(named: "field_other")!
        }
    }
    
    static func list() -> [Mood] {
        return [.startup, .career, .advance, .welfare, .pressure, .advice, .lifestyle, .society, .other]
    }
}

extension Mood {
    init(from decoder: Decoder) throws {
        self = try Mood(rawValue: decoder.singleValueContainer().decode(RawValue.self).lowercased()) ?? .other
    }
}
