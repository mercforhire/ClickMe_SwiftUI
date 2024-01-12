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
    var type: UsersListTypes
    var myUserId: String
    
    @Published var isLoading = false
    @Published var users: [UserProfile] = []
    @Published var isShowingProfile = false
    @Published var selectedProfile: UserProfile?
    
    init(type: UsersListTypes, myUserId: String) {
        self.type = type
        self.myUserId = myUserId
    }
    
    func fetchUsers() {
        isLoading = true
        switch type {
        case .following:
            Task {
                let response = try? await ClickAPI.shared.getFollowingUsers(userId: myUserId)
                if let profiles = response?.data?.profiles {
                    self.users = profiles
                }
                isLoading = false
            }
        case .followers:
            Task {
                let response = try? await ClickAPI.shared.getFollowers(userId: myUserId)
                if let profiles = response?.data?.profiles {
                    self.users = profiles
                }
                isLoading = false
            }
        case .blockedUsers:
            Task {
                let response = try? await ClickAPI.shared.getBlockedUsers(userId: myUserId)
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
