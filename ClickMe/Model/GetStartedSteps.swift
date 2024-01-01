//
//  GetStartedSteps.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import Foundation

enum GetStartedSteps: Int, Identifiable {
    var id: Self {
        return self
    }
    case one
    case two
    case three
    
    static var steps: [GetStartedSteps] {
        return [.one, .two, .three]
    }
    
    func imageName() -> String {
        switch self {
        case .one:
            return "1v1"
        case .two:
            return "group"
        case .three:
            return "8mood"
        }
    }
    
    func title() -> String {
        switch self {
        case .one:
            return "FREE TEXT CHAT"
        case .two:
            return "1-ON-1 VOICE CHAT WITH PROFESSIONALS"
        case .three:
            return "EXPLORE \(Mood.list().count) MOODS"
        }
    }
    
    func body() -> String {
        switch self {
        case .one:
            return "We bring what you love closer to you. Discover and engage with interesting souls. Connect with your community."
        case .two:
            return "Quality communication.\nEarn money while networking.\nMeaningful interactions."
        case .three:
            return "Sharpen your skills, show your talent and get inspired! Let your voice be heard!"
        }
    }
}
