//
//  ExploreTopicsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation
import SwiftUI

@MainActor
final class ExploreTopicsViewModel: ObservableObject {
    @Published var firstTime = true
    @Published var isLoading = false
    @Published var topics: [Topic] = []
    @Published var mood: Mood?
    
    func fetchTopics() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.exploreTopics(mood: mood)
            if let topics = response?.data?.topics {
                self.topics = topics
            }
            isLoading = false
        }
    }
    
    func handleMoodClicked(mood: Mood) {
        if self.mood == mood {
            self.mood = nil
        } else {
            self.mood = mood
        }
        
        fetchTopics()
    }
}
