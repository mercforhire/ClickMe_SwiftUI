//
//  HostBookingFinalViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

@MainActor
final class HostBookingFinalViewModel: ObservableObject {
    var action: BookingAction
    
    var actionImageName: String {
        switch action {
        case .accept:
            return "cheer"
        case .decline:
            return "sad"
        case .cancel:
            return "bad"
        }
    }
    
    var actionSentence: String {
        switch action {
        case .accept:
            return "Booking accepted!"
        case .decline:
            return "Booking rejected!"
        case .cancel:
            return "Booking cancelled!"
        }
    }
    
    init(action: BookingAction) {
        self.action = action
    }
}
