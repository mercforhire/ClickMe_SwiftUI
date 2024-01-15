//
//  BookingStatusViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import Foundation

@MainActor
final class BookingStatusViewModel: ObservableObject {
    var myProfile: UserProfile
    @Published var request: Request
    @Published var receipt: Receipt?
    @Published var review: Review?
    @Published var isLoading = false
    @Published var isShowingProfile = false
    @Published var isShowingCancelModal = false
    @Published var isShowingReview = false
    @Published var actionError: String?
    
    var host: UserProfile {
        return request.hostUser!
    }
    
    var topic: Topic {
        return request.topic!
    }
    
    init(myProfile: UserProfile, request: Request) {
        self.myProfile = myProfile
        self.request = request
    }
    
    func fetchData() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getBookingDetails(requestId: request._id)
            if let request = response?.data?.request {
                self.request = request
                self.receipt = response?.data?.receipt
                self.review = response?.data?.reviews?.first(where: { $0.reviewerId == myProfile.userId })
            }
            isLoading = false
        }
    }
    
    func handleCancelAction(message: String) {
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.requestAction(requestId: request._id, action: .cancel, message: message)
                if response.success {
                    actionError = nil
                    fetchData()
                } else {
                    actionError = "Unknown error"
                }
            } catch {
                switch error {
                case CMError.bookingRequestMustBeApproved:
                    actionError = "Can only cancel an approved booking"
                default:
                    actionError = "Unknown error"
                }
            }
            isLoading = false
        }
    }
    
    func handleStartAction() {
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.startCallingSession(requestId: request._id)
                if let token = response.data?.token {
                    let callSession = CallSession(token: token, callingUser: host, request: request, topic: topic)
                    actionError = nil
                    fetchData()
                    print("go to calling screen using session:")
                    print(callSession)
                    NotificationCenter.default.post(name: Notifications.JoinACall, object: nil, userInfo: ["session": callSession])
                } else {
                    actionError = "Unknown error"
                }
            } catch {
                switch error {
                case CMError.tooEarlyToStartSession:
                    actionError = "Too early to start the voice session, wait within 5 minutes of start time"
                case CMError.alreadyPastSessionEndTime:
                    actionError = "Already past the end of session, too late to start now"
                default:
                    actionError = "Unknown error"
                }
            }
            isLoading = false
        }
    }
    
    func handleChatButton() {
        NotificationCenter.default.post(name: Notifications.SwitchToChat, object: nil, userInfo: ["user": host])
    }
    
    func handleRefreshBookingRequest(notification: NotificationCenter.Publisher.Output) {
        if let request = notification.userInfo?["request"] as? Request, request._id == self.request._id {
            fetchData()
        }
    }
}
