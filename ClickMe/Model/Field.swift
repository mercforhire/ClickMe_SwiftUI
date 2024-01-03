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
    
    func icon() -> UIImage {
        switch self {
        case .business:
            return UIImage(named: "field_business")!
        case .social:
            return UIImage(named: "field_social")!
        case .tech:
            return UIImage(named: "field_tech")!
        case .entertainment:
            return UIImage(named: "field_entertainment")!
        case .education:
            return UIImage(named: "field_education")!
        case .media:
            return UIImage(named: "field_media")!
        case .science:
            return UIImage(named: "field_science")!
        case .other:
            return UIImage(named: "field_other")!
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
