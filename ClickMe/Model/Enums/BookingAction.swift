//
//  BookingAction.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation

enum BookingAction {
    case accept
    case decline
    case cancel
    
    func actionText() -> String {
        switch self {
        case .accept:
            return "Accept"
        case .decline:
            return "Decline"
        case .cancel:
            return "Cancel"
        }
    }
}
