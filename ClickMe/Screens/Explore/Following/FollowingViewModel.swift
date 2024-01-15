//
//  FollowingViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-15.
//

import Foundation
import SwiftUI

@MainActor
final class FollowingViewModel: ObservableObject {
    var myProfile: UserProfile
    
    @Published var profiles: [UserProfile] = []
    @Published var isShowingProfile = false
    @Published var selectedProfile: UserProfile?
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }
    
    func fetchFollowingUsers() {
        Task {
            let response = try? await ClickAPI.shared.getFollowingUsers(userId: myProfile.userId)
            if let profiles = response?.data?.profiles {
                self.profiles = profiles
            }
        }
    }
}
