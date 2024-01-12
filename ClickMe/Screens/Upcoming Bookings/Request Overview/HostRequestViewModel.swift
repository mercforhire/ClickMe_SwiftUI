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
    @Published var callSession: CallSession?
    @Published var actionMessage: String = ""
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
    
    func handleAcceptAction() {
        guard checkIfMessageIsFilled() else { return }
        
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.requestAction(requestId: request._id, action: .accept, message: actionMessage)
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
    
    func handleDeclineAction() {
        guard checkIfMessageIsFilled() else { return }
        
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.requestAction(requestId: request._id, action: .decline, message: actionMessage)
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
    
    func handleCancelAction() {
        guard checkIfMessageIsFilled() else { return }
        
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.requestAction(requestId: request._id, action: .cancel, message: actionMessage)
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
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.startCallingSession(requestId: request._id)
                if let callSession = response.data?.session {
                    self.callSession = callSession
                    actionError = nil
                                        goToCallScreen = true
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
        NotificationCenter.default.post(name: Notifications.SwitchToChat, object: nil, userInfo: ["user": booker])
    }
}
