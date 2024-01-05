//
//  FollowingsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation
import SwiftUI

@MainActor
final class FollowingsViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var isShowingProfile = false
    @Published var selectedProfile: UserProfile?
    
    func fetchUsers() {
        guard let myUserId = UserManager.shared.user?._id else {
            return
        }
        
        Task {
            let response = try? await ClickAPI.shared.getFollowingUsers(userId: myUserId)
            if let profiles = response?.data?.profiles {
                self.profiles = profiles
            }
        }
    }
}
