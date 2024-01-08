//
//  MyBookingsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import Foundation
import SwiftUI

@MainActor
final class MyBookingsViewModel: ObservableObject {
    var myUserId: String
    
    @Published var isLoading = false
    @Published var requests: [Request] = []
    @Published var selectedRequest: Request?
    
    init(myUserId: String) {
        self.myUserId = myUserId
    }
    
    func fetchRequests() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getGuestBookingRequests(userId: myUserId)
            if let requests = response?.data?.requests {
                self.requests = requests
            }
            isLoading = false
        }
    }
}
