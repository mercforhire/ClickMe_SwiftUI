//
//  UsersListViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation

enum UsersListTypes {
    case following
    case followers
    case blockedUsers
    
    func title() -> String {
        switch self {
        case .following:
            return "Following users"
        case .followers:
            return "My followers"
        case .blockedUsers:
            return "Blocked users"
        }
    }
}

@MainActor
final class UsersListViewModel: ObservableObject {
    var myProfile: UserProfile
    var type: UsersListTypes
    
    @Published var isLoading = false
    @Published var users: [UserProfile] = []
    @Published var isShowingProfile = false
    @Published var selectedProfile: UserProfile?
    
    init(myProfile: UserProfile, type: UsersListTypes) {
        self.myProfile = myProfile
        self.type = type
    }
    
    func fetchUsers() {
        isLoading = true
        switch type {
        case .following:
            Task {
                let response = try? await ClickAPI.shared.getFollowingUsers(userId: myProfile.userId)
                if let profiles = response?.data?.profiles {
                    self.users = profiles
                }
                isLoading = false
            }
        case .followers:
            Task {
                let response = try? await ClickAPI.shared.getFollowers(userId: myProfile.userId)
                if let profiles = response?.data?.profiles {
                    self.users = profiles
                }
                isLoading = false
            }
        case .blockedUsers:
            Task {
                let response = try? await ClickAPI.shared.getBlockedUsers(userId: myProfile.userId)
                if let profiles = response?.data?.profiles {
                    self.users = profiles
                }
                isLoading = false
            }
        }
    }
    
    func unfollowUser(user: UserProfile) {
        Task {
            let response = try? await ClickAPI.shared.unfollow(followingUserId: user.id)
            if response?.success ?? false {
                fetchUsers()
            }
        }
    }
    
    func unblockUser(user: UserProfile) {
        Task {
            let response = try? await ClickAPI.shared.unblock(blockUserId: user.id)
            if response?.success ?? false {
                fetchUsers()
            }
        }
    }
}
