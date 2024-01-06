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
    @Published var topics: [Topic] = []
    @Published var mood: Mood?
    @Published var isShowingTopic: Bool = false
    @Published var selectedTopic: Topic?
    
    func fetchTopics() {
        Task {
            let response = try? await ClickAPI.shared.exploreTopics(mood: mood)
            if let topics = response?.data?.topics {
                self.topics = topics
            }
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
