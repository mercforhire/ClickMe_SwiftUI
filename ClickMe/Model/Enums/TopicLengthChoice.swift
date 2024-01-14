//
//  TopicLengthChoice.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-13.
//

import Foundation

enum TopicLengthChoice: Int, Identifiable {
    case min_15
    case min_30
    case min_45
    case hour_1
    case hour_1_30_min
    case hour_2
    case hour_2_hour_30_min
    case hour_3
    
    var id: Int { self.rawValue }
    
    func text() -> String {
        switch self {
        case .min_15:
            return "15 min"
        case .min_30:
            return "30 min"
        case .min_45:
            return "45 min"
        case .hour_1:
            return "1 hour"
        case .hour_1_30_min:
            return "1 hour and half"
        case .hour_2:
            return "2 hours"
        case .hour_2_hour_30_min:
            return "2 hours and half"
        case .hour_3:
            return "3 hours"
        }
    }
    
    func numberOfMins() -> Int {
        switch self {
        case .min_15:
            return 15
        case .min_30:
            return 30
        case .min_45:
            return 45
        case .hour_1:
            return 60
        case .hour_1_30_min:
            return 90
        case .hour_2:
            return 120
        case .hour_2_hour_30_min:
            return 150
        case .hour_3:
            return 180
        }
    }
    
    static func list() -> [TopicLengthChoice] {
        [.min_15, .min_30, .min_45, .hour_1, .hour_1_30_min, .hour_2, .hour_2_hour_30_min, .hour_3]
    }
    
    static func enumFromMinutes(minutes: Int) -> TopicLengthChoice {
        for choice in TopicLengthChoice.list() {
            if minutes <= choice.numberOfMins() {
                return choice
            }
        }
        
        return .hour_3
    }
}
