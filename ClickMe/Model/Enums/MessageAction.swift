//
//  MessageAction.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation

enum MessageAction: String, Codable {
    case BOOKING_ATTEMPT
    case BOOKING_REQUEST
    case APPROVED
    case DECLINED
    case CANCEL
    case unknown
    
    func text() -> String {
        switch self {
        case .BOOKING_ATTEMPT:
            return "Booking attempted"
        case .BOOKING_REQUEST:
            return "Booking request"
        case .APPROVED:
            return "Booking approved"
        case .DECLINED:
            return "Booking declined"
        case .CANCEL:
            return "Booking cancelled"
        case .unknown:
            return "Unknown action"
        }
    }
}

extension MessageAction {
    init(from decoder: Decoder) throws {
        self = try MessageAction(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
