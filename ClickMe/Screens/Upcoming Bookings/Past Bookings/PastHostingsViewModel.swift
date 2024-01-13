//
//  HostPastBookingsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation

@MainActor
final class PastHostingsViewModel: ObservableObject {
    var myProfile: UserProfile
    
    @Published var isLoading = false
    @Published var requests: [Request] = []
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }
    
    func fetchRequests() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getHostPastBookingRequests(userId: myProfile.userId)
            if let requests = response?.data?.requests {
                self.requests = requests
            }
            isLoading = false
        }
    }
}
