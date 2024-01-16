//
//  FollowingTopicsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-16.
//

import Foundation

@MainActor
final class FollowingTopicsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var topics: [Topic] = []
    
    func fetchTopics() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getFollowingTopics()
            if let topics = response?.data?.topics {
                self.topics = topics
            }
            isLoading = false
        }
    }
}
