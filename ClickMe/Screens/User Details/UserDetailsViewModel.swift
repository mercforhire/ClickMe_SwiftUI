//
//  UserDetailsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation
import SwiftUI

@MainActor
final class UserDetailsViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var tabSelection = 0
    @Published var following = false
    @Published var topics: [Topic] = []
    
    func getUserTopics() {
        guard let profile else { return }
        
        Task {
            let response = try? await ClickAPI.shared.getUserTopics(userId: profile.userId)
            if let topics = response?.data?.topics {
                self.topics = topics
            }
        }
    }
}
