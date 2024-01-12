//
//  BookingStatusViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import Foundation

@MainActor
final class BookingStatusViewModel: ObservableObject {
    @Published var request: Request
    @Published var receipt: Receipt?
    @Published var isLoading = false
    @Published var isShowingProfile = false
    @Published var actionMessage: String = ""
    @Published var isShowingCancelModal = false
    @Published var actionError: String?
    @Published var actionComplete = false
    @Published var callSession: CallSession?
    
    var host: UserProfile {
        return request.hostUser!
    }
    
    var topic: Topic {
        return request.topic!
    }
    
    init(request: Request) {
        self.request = request
    }
    
    func checkIfMessageIsFilled() -> Bool {
        if actionMessage.isEmpty {
            actionError = "Please enter a message"
            return false
        }
        
        actionError = nil
        return true
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
    
    func handleCancelAction() {
        guard checkIfMessageIsFilled() else { return }
        
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.requestAction(requestId: request._id, action: .cancel, message: actionMessage)
                if response.success {
                    actionError = nil
                    actionComplete = true
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
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.startCallingSession(requestId: request._id)
                if let callSession = response.data?.session {
                    self.callSession = callSession
                    actionError = nil
                    actionComplete = true
                    print("go to calling screen using session:")
                    print(callSession)
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
}
