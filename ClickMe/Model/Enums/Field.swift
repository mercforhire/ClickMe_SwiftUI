//
//  Field.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import UIKit

enum Field: String, Codable, Identifiable {
    case business
    case social
    case tech
    case entertainment
    case education
    case media
    case science
    case other
    
    var id: Field { self }
    
    func text() -> String {
        switch self {
        case .business:
            return "Business"
        case .social:
            return "Social"
        case .tech:
            return "Tech"
        case .entertainment:
            return "Entertainment"
        case .education:
            return "Education"
        case .media:
            return "Media"
        case .science:
            return "Science"
        case .other:
            return "Other"
        }
    }
    
    func imageName() -> String {
        switch self {
        case .business:
            return "field_business"
        case .social:
            return "field_social"
        case .tech:
            return "field_tech"
        case .entertainment:
            return "field_entertainment"
        case .education:
            return "field_education"
        case .media:
            return "field_media"
        case .science:
            return "field_science"
        case .other:
            return "field_other"
        }
    }
    
    static func list() -> [Field] {
        return [.business, .social, .tech, .entertainment, .education, .media, .science, .other]
    }
}

extension Field {
    init(from decoder: Decoder) throws {
        self = try Field(rawValue: decoder.singleValueContainer().decode(RawValue.self).lowercased()) ?? .other
    }
}
