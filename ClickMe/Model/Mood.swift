//
//  Mood.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import Foundation

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
    
    func imageName() -> String {
        switch self {
        case .startup:
            return "mood_startup"
        case .career:
            return "mood_career"
        case .advance:
            return "mood_advance"
        case .welfare:
            return "mood_welfare"
        case .pressure:
            return "mood_pressure"
        case .advice:
            return "mood_advice"
        case .lifestyle:
            return "mood_lifestyle"
        case .society:
            return "mood_social"
        case .other:
            return "field_other"
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
