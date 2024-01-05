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
    @Published var searchResults: [UserProfile] = []
    @Published var isPresentingFilter = false
    @Published var searchText = ""
    @Published var searchIsActive = false
    
    @Published var isShowingProfile = false
    @Published var selectedProfile: UserProfile?
    
    func fetchUsers(filter: ExploreUsersParams) {
        Task {
            let response = try? await ClickAPI.shared.explore(params: filter)
            if let profiles = response?.data {
                self.profiles = profiles
            }
        }
    }
    
    func searchUsers() {
        guard searchText.count >= 3 else { return }
        
        Task {
            let response = try? await ClickAPI.shared.searchUsers(params: SearchUsersParams(keyword: searchText))
            if let searchResults = response?.data?.results {
                self.searchResults = searchResults
            }
        }
    }
    
    func toggleSearchIsActive() {
        searchIsActive.toggle()
        if !searchIsActive {
            searchText = ""
            searchResults = []
        }
    }
}
