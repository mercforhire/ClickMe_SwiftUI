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
    var myProfile: UserProfile
    @Published var profile: UserProfile
    @Published var following = false
    @Published var topics: [Topic] = []
    @Published var ratings: Double?
    
    var lookingAtMySelf: Bool {
        return myProfile.userId == profile.userId
    }
    
    init(myProfile: UserProfile, profile: UserProfile) {
        self.myProfile = myProfile
        self.profile = profile
    }
    
    func getUserTopics() {
        Task {
            let response = try? await ClickAPI.shared.getUserTopics(userId: profile.userId)
            if let topics = response?.data?.topics {
                self.topics = topics
            }
        }
    }
    
    func getFollowStatus() {
        Task {
            let response = try? await ClickAPI.shared.getFollowStatus(followerUserId: myProfile.userId, followingUserId: profile.id)
            if let message = response?.message, message == "FOLLOW_RECORD_EXIST" {
                following = true
            } else {
                following = false
            }
        }
    }
    
    func getRatings() {
        Task {
            let response = try? await ClickAPI.shared.getUserRatings(userId: profile.id)
            if let ratings = response?.data?.avgRatings {
                self.ratings = ratings
            }
        }
    }
    
    func handleChatButton() {
        NotificationCenter.default.post(name: Notifications.SwitchToChat, object: nil, userInfo: ["user": profile])
    }
    
    func handleFollowButton() {
        if following {
            unfollowUser()
        } else {
            followUser()
        }
    }
    
    func followUser() {
        Task {
            let response = try? await ClickAPI.shared.follow(followingUserId: profile.id)
            if response?.success ?? false {
                following = true
                refreshProfile()
            }
        }
    }
    
    func unfollowUser() {
        Task {
            let response = try? await ClickAPI.shared.unfollow(followingUserId: profile.id)
            if response?.success ?? false {
                following = false
                refreshProfile()
            }
        }
    }
    
    func refreshProfile() {
        Task {
            let response = try? await ClickAPI.shared.getUserProfile(userId: profile.id)
            if let profile = response?.data?.profile {
                self.profile = profile
            }
        }
    }
    
    func handleOpenTopic(topic: Topic) {
        NotificationCenter.default.post(name: Notifications.SwitchToTopic, object: nil, userInfo: ["topic": topic])
    }
}
