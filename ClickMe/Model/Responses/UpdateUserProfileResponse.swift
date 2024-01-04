//
//  UpdateUserProfileResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import Foundation

struct UpdateUserProfileResponse: Codable {
    let success: Bool
    let message: String
    var data: UpdateUserProfileData?
}

struct UpdateUserProfileData: Codable {
    var profile: UserProfile?
}
