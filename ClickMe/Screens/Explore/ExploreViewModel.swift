//
//  ExploreViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import Foundation
import SwiftUI

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var filterViewModel = ExploreFilterViewModel()
    @Published var isPresentingFilter = false
    @Published var searchText = ""
    @Published var searchIsActive = false
    
    func fetchUsers() {
        Task {
            let response = try? await ClickAPI.shared.explore(params: filterViewModel.toExploreUsersParams())
            if let profiles = response?.data {
                self.profiles = profiles
            }
        }
    }
    
    func toggleSearchIsActive() {
        searchIsActive.toggle()
    }
}
