//
//  MyPastBookingsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import Foundation
import SwiftUI

@MainActor
final class MyPastBookingsViewModel: ObservableObject {
    var myUserId: String
    
    @Published var isLoading = false
    @Published var requests: [Request] = []
    
    init(myUserId: String) {
        self.myUserId = myUserId
    }
    
    func fetchRequests() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getGuestPastBookingRequests(userId: myUserId)
            if let requests = response?.data?.requests {
                self.requests = requests
            }
            isLoading = false
        }
    }
}
