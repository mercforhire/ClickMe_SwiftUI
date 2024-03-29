//
//  UserProfile.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct UserProfile: Codable, Identifiable, Hashable {
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
    var numberFollowing: Int?
    
    var avatarThumbnailUrl: String? {
        userPhotos?.first?.thumbnail
    }
    
    var avatarUrl: String? {
        userPhotos?.first?.url
    }
    
    var fullName: String {
        "\(firstName ?? "") \(lastName ?? "")"
    }
    
    static func getUser(from participants: [UserProfile], of userId: String) -> UserProfile? {
        return participants.first(where: { $0.userId == userId })
    }
}
