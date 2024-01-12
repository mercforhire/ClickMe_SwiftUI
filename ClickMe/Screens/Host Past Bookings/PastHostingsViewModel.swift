//
//  HostPastBookingsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation

@MainActor
final class PastHostingsViewModel: ObservableObject {
    var myUserId: String
    
    @Published var isLoading = false
    @Published var requests: [Request] = []
    
    init(myUserId: String) {
        self.myUserId = myUserId
    }
    
    func fetchRequests() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getHostPastBookingRequests(userId: myUserId)
            if let requests = response?.data?.requests {
                self.requests = requests
            }
            isLoading = false
        }
    }
}
