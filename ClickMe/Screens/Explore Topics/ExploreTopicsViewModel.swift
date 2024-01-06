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
    @Published var moodFilter: Mood?
    
    func fetchTOpics(moodFilter: Mood?) {
        Task {
            let response = try? await ClickAPI.shared.explore(params: filter)
            if let profiles = response?.data {
                self.profiles = profiles
            }
        }
    }
}
