//
//  InboxViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

@MainActor
final class InboxViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var conversations: [Conversation] = []
    @Published var selectedConversation: Conversation?
    
    var myProfile: UserProfile? {
        return UserManager.shared.profile
    }
    
    var talkingTo: UserProfile? {
        guard let selectedConversation, let myUserId = myProfile?.userId else { return nil }
        
        for participant in selectedConversation.participants {
            if participant.userId != myUserId {
                return participant
            }
        }
        return nil
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
}
