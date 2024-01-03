//
//  LoginResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let data: LoginData?
}

struct LoginData: Codable {
    let user: User?
    let profile: UserProfile?
}
