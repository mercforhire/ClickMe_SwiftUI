//
//  GetUserProfileResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct GetUserProfileResponse: Codable {
    let success: Bool
    let message: String
    var data: GetUserProfileData?
}

struct GetUserProfileData: Codable {
    var profile: UserProfile?
    var userId: String?
}
