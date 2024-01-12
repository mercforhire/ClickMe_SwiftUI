//
//  HostRequestViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation

@MainActor
final class HostRequestViewModel: ObservableObject {
    @Published var request: Request
    @Published var receipt: Receipt?
    @Published var isLoading = false
    @Published var isShowingProfile = false
    
    var host: UserProfile {
        return request.hostUser!
    }
    
    var topic: Topic {
        return request.topic!
    }
    
    init(request: Request) {
        self.request = request
    }
    
    func fetchData() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getBookingDetails(requestId: request._id)
            if let request = response?.data?.request {
                self.request = request
                self.receipt = response?.data?.receipt
            }
            isLoading = false
        }
    }
    
    func handleChatButton() {
        NotificationCenter.default.post(name: Notifications.SwitchToChat, object: nil, userInfo: ["user": host])
    }
}
