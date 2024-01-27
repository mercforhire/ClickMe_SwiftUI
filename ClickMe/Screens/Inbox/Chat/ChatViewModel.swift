//
//  ChatViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import Foundation
import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    var myProfile: UserProfile
    var talkingTo: UserProfile
    var participants: [UserProfile] {
        return [myProfile, talkingTo]
    }
    
    @Published var isLoading = false
    @Published var isSending = false
    @Published var hash: String?
    @Published var messages: [Message] = []
    @Published var scrollToBottom: Bool = true // anytime this changes, trigger scroll to bottom
    @Published var typingMessage: String = ""
    @Published var blocked = false
    @Published var otherPersonBlockedMe = false
    
    private var refreshTimer: Timer?
    
    init(myProfile: UserProfile, talkingTo: UserProfile) {
        self.myProfile = myProfile
        self.talkingTo = talkingTo
    }
    
    func fetchMessages() {
        Task {
            messages.isEmpty ? isLoading = true : nil
            let response = try? await ClickAPI.shared.getChatMessages(with: talkingTo.userId)
            if let messages = response?.data?.messages {
                self.messages = messages
                scheduleScrollToBottom()
            }
            isLoading = false
        }
    }
    
    func fetchMessagesHash() {
        Task {
            let response = try? await ClickAPI.shared.getChatMessagesHash(with: talkingTo.userId)
            if let hash = response?.data?.hash {
                if self.hash != hash  {
                    self.hash = hash
                    fetchMessages()
                }
            }
        }
    }
    
    func sendChatMessage() {
        guard !typingMessage.isEmpty else { return }
        
        Task {
            isSending = true
            let response = try? await ClickAPI.shared.sendChatMessage(toUserId: talkingTo.userId, message: typingMessage)
            if let newMessage = response?.data?.message {
                self.messages.append(newMessage)
                scheduleScrollToBottom()
                typingMessage = ""
            }
            isSending = false
        }
    }
    
    func getBlockStatus() {
        Task {
            let response = try? await ClickAPI.shared.getBlockStatus(userId: myProfile.userId, blockUserId: talkingTo.userId)
            if let message = response?.message, message == "NO_BLOCK_RECORD" {
                blocked = false
            } else if let message = response?.message, message == "BLOCK_RECORD_EXIST" {
                blocked = true
            }
        }
        
        Task {
            let response = try? await ClickAPI.shared.getBlockStatus(userId: talkingTo.userId, blockUserId: myProfile.userId)
            if let message = response?.message, message == "NO_BLOCK_RECORD" {
                otherPersonBlockedMe = false
            } else if let message = response?.message, message == "BLOCK_RECORD_EXIST" {
                otherPersonBlockedMe = true
            }
        }
    }
    
    func handleBlockButton() {
        if blocked {
            unblockUser()
        } else {
            blockUser()
        }
    }
    
    func blockUser() {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.block(blockUserId: talkingTo.userId, reason: "")
            if response?.success ?? false {
                blocked = true
            }
            isLoading = false
        }
    }
    
    func unblockUser() {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.unblock(blockUserId: talkingTo.userId)
            if response?.success ?? false {
                blocked = false
            }
            isLoading = false
        }
    }
    
    func scheduleScrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollToBottom.toggle()
        }
    }
    
    func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 5,
                                            target: self,
                                            selector: #selector(timerFunction),
                                            userInfo: nil,
                                            repeats: true)
        refreshTimer?.fire()
    }
    
    @objc func timerFunction() {
        fetchMessagesHash()
    }
    
    func stopRefreshTime() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    func handleOpenTopic(topic: Topic) {
        NotificationCenter.default.post(name: Notifications.SwitchToTopic, object: nil, userInfo: ["topic": topic])
    }
}
