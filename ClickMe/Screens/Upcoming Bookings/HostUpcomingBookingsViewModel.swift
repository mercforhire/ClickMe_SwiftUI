//
//  HostUpcomingBookingsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation

@MainActor
final class HostUpcomingBookingsViewModel: ObservableObject {
    var myProfile: UserProfile
    
    @Published var isLoading = false
    @Published var requests: [Request] = [] {
        didSet {
            calculateNumbers()
        }
    }
    @Published var requestsPending: Int = 0
    @Published var bookingsToday: Int = 0
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }
    
    func fetchRequests() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getHostBookingRequests(userId: myProfile.userId)
            if let requests = response?.data?.requests {
                self.requests = requests
            }
            isLoading = false
        }
    }
    
    func calculateNumbers() {
        requestsPending = requests.filter { subject in
            return subject.status == .PENDING_APPROVAL
        }.count
        
        bookingsToday = requests.filter { subject in
            return subject.startTime.isInToday()
        }.count
    }
}
