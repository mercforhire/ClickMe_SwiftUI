//
//  LoginData.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct LoginData: Codable {
    let user: User?
    let profile: UserProfile?
}

struct User: Codable {
    let email: String?
    let apiKey: String?
}

struct UserProfile: Codable {
    let screenId: String?
    let firstName: String?
    let lastName: String?
    let city: String?
    let state: String?
    let country: String?
    let jobTitle: String?
    let company: String?
    let field: String?
    let degree: String?
    let aboutMe: String?
    let expertise: [String]?
    let interests: [String]?
    let userPhotos: [String]?
    let languages: [String]?
}
