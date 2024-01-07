//
//  TopicDetailsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation
import SwiftUI

@MainActor
final class TopicDetailsViewModel: ObservableObject {
    @Published var topic: Topic
    @Published var isShowingProfile = false
    
    init(topic: Topic) {
        self.topic = topic
    }
    
    func refreshTopic() {
        Task {
            let response = try? await ClickAPI.shared.getTopic(topicId: topic._id)
            if let topic = response?.data?.topic {
                self.topic = topic
            }
        }
    }
}
