//
//  BlockReason.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

enum BlockReason {
    case fake
    case spam
    case fraud
    case porn
    case harrass
    case other
    
    func text() -> String {
        switch self {
        case .fake:
            return "Fake profile"
        case .spam:
            return "Advertiser/Spam"
        case .fraud:
            return "Fraud"
        case .porn:
            return "Explicit Content"
        case .harrass:
            return "Profanity/Harassment"
        case .other:
            return "Others"
        }
    }
    
    static func list() -> [BlockReason] {
        return [.fake, .spam, .fraud, .porn, .harrass, .other]
    }
}
