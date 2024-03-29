//
//  GetsUsersResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation

struct GetUsersResponse: Codable {
    let success: Bool
    let message: String
    var data: FollowingUsersData?
}

struct FollowingUsersData: Codable {
    var profiles: [UserProfile]
}
