//
//  ExploreUsersResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import Foundation

struct ExploreUsersResponse: Codable {
    let success: Bool
    let message: String
    var data: [UserProfile]?
}
