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
    @Published var isLoading = false
    @Published var isSending = false
    @Published var messages: [Message] = []
    @Published var scrollToBottom: Bool = true // anytime this changes, trigger scroll to bottom
    @Published var typingMessage: String = ""
    @Published var blocked = false
    @Published var otherPersonBlockedMe = false
    
    init(myProfile: UserProfile, talkingTo: UserProfile) {
        self.myProfile = myProfile
        self.talkingTo = talkingTo
    }
    
    func fetchMessages() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getChatMessages(with: talkingTo.userId)
            if let messages = response?.data?.messages {
                self.messages = messages
                scrollToBottom.toggle()
            }
            isLoading = false
        }
    }
    
    func sendChatMessage() {
        guard !typingMessage.isEmpty else { return }
        
        Task {
            isSending = true
            let response = try? await ClickAPI.shared.sendChatMessage(toUserId: talkingTo.userId, message: typingMessage)
            if let newMessage = response?.data?.message {
                self.messages.append(newMessage)
                scrollToBottom.toggle()
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
            } else {
                blocked = false
            }
        }
        
        Task {
            let response = try? await ClickAPI.shared.getBlockStatus(userId: talkingTo.userId, blockUserId: myProfile.userId)
            if let message = response?.message, message == "NO_BLOCK_RECORD" {
                otherPersonBlockedMe = false
            } else if let message = response?.message, message == "BLOCK_RECORD_EXIST" {
                otherPersonBlockedMe = true
            } else {
                otherPersonBlockedMe = false
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
        Task {
            let response = try? await ClickAPI.shared.block(blockUserId: talkingTo.userId)
            if response?.success ?? false {
                blocked = true
            }
        }
    }
    
    func unblockUser() {
        Task {
            let response = try? await ClickAPI.shared.unblock(blockUserId: talkingTo.userId)
            if response?.success ?? false {
                blocked = false
            }
        }
    }
}
