//
//  InboxViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

@MainActor
final class InboxViewModel: ObservableObject {
    var myProfile: UserProfile
    @Published var firstTime = true
    @Published var isLoading = false
    @Published var hash: String?
    @Published var conversations: [Conversation] = []
    @Published var selectedConversation: Conversation?
    
    private var refreshTimer: Timer?
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }

    func fetchConversations() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getConversations()
            if let conversations = response?.data?.conversations {
                self.conversations = conversations
            }
            isLoading = false
        }
    }
    
    func fetchConversationsHash() {
        Task {
            let response = try? await ClickAPI.shared.getConversationsHash()
            if let hash = response?.data?.hash {
                self.hash != hash ? self.hash = hash : nil
                print("getConversationsHash: ", hash)
            }
        }
    }
    
    func getOtherConversationParticipant() -> UserProfile? {
        guard let selectedConversation else { return nil }
        
        for participant in selectedConversation.participants {
            if participant.userId != myProfile.userId {
                return participant
            }
        }
        return nil
    }
    
    func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 10,
                                            target: self,
                                            selector: #selector(timerFunction),
                                            userInfo: nil,
                                            repeats: true)
        refreshTimer?.fire()
    }
    
    @objc func timerFunction() {
        fetchConversationsHash()
    }
    
    func stopRefreshTime() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
