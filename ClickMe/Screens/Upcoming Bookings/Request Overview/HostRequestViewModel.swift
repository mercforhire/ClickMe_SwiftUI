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
    @Published var review: Review?
    
    @Published var isLoading = false
    @Published var isShowingProfile = false
    @Published var isShowingAcceptModal = false
    @Published var isShowingDeclineModal = false
    @Published var isShowingCancelModal = false
    @Published var actionError: String?
    @Published var goToCallScreen = false
    
    var booker: UserProfile {
        return request.bookingUser!
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
                self.review = response?.data?.reviews?.first(where: { $0.reviewerId == booker.userId })
            }
            isLoading = false
        }
    }
    
    func handleAcceptAction(message: String) {
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.requestAction(requestId: request._id, action: .accept, message: message)
                if response.success {
                    actionError = nil
                    fetchData()
                } else {
                    actionError = "Unknown error"
                }
            } catch {
                switch error {
                case CMError.bookingRequestMustBePending:
                    actionError = "Booking request is not pending approval"
                default:
                    actionError = "Unknown error"
                }
            }
            isLoading = false
        }
    }
    
    func handleDeclineAction(message: String) {
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.requestAction(requestId: request._id, action: .decline, message: message)
                if response.success {
                    actionError = nil
                    fetchData()
                } else {
                    actionError = "Unknown error"
                }
            } catch {
                switch error {
                case CMError.bookingRequestMustBePending:
                    actionError = "Booking request is not pending approval"
                default:
                    actionError = "Unknown error"
                }
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
                    actionError = "Can only cancel already approved booking"
                default:
                    actionError = "Unknown error"
                }
            }
            isLoading = false
        }
    }
    
    func handleStartAction() {
        Task {
            let microphonePermission = await AgoraManager.checkForPermissions()
            if !microphonePermission {
                return
            }
            
            isLoading = true
            do {
                let response = try await ClickAPI.shared.startCallingSession(requestId: request._id)
                if let token = response.data?.token {
                    let callSession = CallSession(token: token, callingUser: booker, request: request, topic: topic)
                    actionError = nil
                    goToCallScreen = true
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
        NotificationCenter.default.post(name: Notifications.SwitchToChat, object: nil, userInfo: ["user": booker])
    }
}
