//
//  HostTopicsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-13.
//

import Foundation

@MainActor
final class HostTopicsViewModel: ObservableObject {
    var myProfile: UserProfile
    
    @Published var isLoading = false
    @Published var topics: [Topic] = []
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }
    
    func fetchTopics() {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.getUserTopics(userId: myProfile.userId)
            if let topics = response?.data?.topics {
                self.topics = topics
            }
            isLoading = false
        }
    }
}

