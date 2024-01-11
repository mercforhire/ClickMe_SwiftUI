//
//  Language.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation

enum Language: String, Codable, Identifiable, Hashable {
    case english
    case chinese
    case spanish
    case french
    case tagalog
    case vietnamese
    case german
    case arabic
    case korean
    case other
    
    var id: Language { self }
    
    func text() -> String {
        switch self {
        case .english:
            return "English"
        case .chinese:
            return "Chinese"
        case .spanish:
            return "Spanish"
        case .french:
            return "French"
        case .tagalog:
            return "Tagalog"
        case .vietnamese:
            return "Vietnamese"
        case .german:
            return "German"
        case .arabic:
            return "Arabic"
        case .korean:
            return "Korean"
        case .other:
            return "Other"
        }
    }
    
    static func list() -> [Language] {
        return [.english, .chinese, .spanish, .french, .tagalog, .vietnamese, .german, .arabic, .korean, .other]
    }
}

extension Language {
    init(from decoder: Decoder) throws {
        self = try Language(rawValue: decoder.singleValueContainer().decode(RawValue.self).lowercased()) ?? .other
    }
}
