//
//  UserProfile.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct UserProfile: Codable, Identifiable {
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
    
    static func mockProfile() -> UserProfile {
        return UserProfile(userId: "6597171ad4f4d7af9f97da76", screenId: "0dm3r8rby0", firstName: "Federico", lastName: "Wiegand", city: "Melodyview", state: "Washington", country: .canada, jobTitle: "Regional Group Technician", company: "Larkin LLC", field: .science, degree: "Paradigm", aboutMe: "Curo dolores cornu demulceo distinctio cunae truculenter clibanus.", userPhotos: [Photo(thumbnail: "https://picsum.photos/id/524/300/500", url: "https://picsum.photos/id/524/300/500"), Photo(thumbnail: "https://picsum.photos/id/524/300/500", url: "https://picsum.photos/id/524/300/500"), Photo(thumbnail: "https://picsum.photos/id/524/300/500", url: "https://picsum.photos/id/524/300/500")], languages: [.english, .french], numberOfFollowers: 55)
    }
}
