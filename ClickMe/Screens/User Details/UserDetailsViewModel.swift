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
    
    func getFollowStatus() {
        guard let myUserId = UserManager.shared.user?._id, 
                let profile else {
            return
        }
        
        Task {
            let response = try? await ClickAPI.shared.getFollowStatus(followerUserId: myUserId, followingUserId: profile.id)
            if let message = response?.message, message == "FOLLOW_RECORD_EXIST" {
                following = true
            } else {
                following = false
            }
        }
    }
    
    func handleFollowButton() {
        if following {
            unfollowUser()
        } else {
            followUser()
        }
    }
    
    func followUser() {
        guard let profile else { return }
        
        Task {
            let response = try? await ClickAPI.shared.follow(followingUserId: profile.id)
            if response?.success ?? false {
                following = true
                refreshProfile()
            }
        }
    }
    
    func unfollowUser() {
        guard let profile else { return }
        
        Task {
            let response = try? await ClickAPI.shared.unfollow(followingUserId: profile.id)
            if response?.success ?? false {
                following = false
                refreshProfile()
            }
        }
    }
    
    func refreshProfile() {
        guard let profile else { return }
        
        Task {
            let response = try? await ClickAPI.shared.getUserProfile(userId: profile.id)
            if let profile = response?.data?.profile {
                self.profile = profile
            }
        }
    }
}
