//
//  UserProfile.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct UserProfile: Codable, Identifiable, Equatable {
    var id: String { return userId }
    let userId: String
    let screenId: String
    let firstName: String?
    let lastName: String?
    let city: String?
    let state: String?
    let country: Country?
    let jobTitle: String?
    let company: String?
    let field: Field?
    let degree: String?
    let aboutMe: String?
    let userPhotos: [Photo]?
    let languages: [Language]?
    var numberOfFollowers: Int?
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.userId == rhs.userId
    }
}
