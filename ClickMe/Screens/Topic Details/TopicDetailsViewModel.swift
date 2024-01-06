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
    @Published var topic: Topic?
    
    func refreshTopic() {
        guard let topic else { return }
        
        Task {
            let response = try? await ClickAPI.shared.getTopic(topicId: topic._id)
            if let topic = response?.data?.topic {
                self.topic = topic
            }
        }
    }
}
