//
//  SearchUsersResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation

struct SearchUsersResponse: Codable {
    let success: Bool
    let message: String
    var data: SearchUsersData?
}

struct SearchUsersData: Codable {
    let keyword: String
    var results: [UserProfile]
}
