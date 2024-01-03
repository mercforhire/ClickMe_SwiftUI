//
//  UserProfile.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct UserProfile: Codable {
    let userId: String?
    let screenId: String?
    let firstName: String?
    let lastName: String?
    let city: String?
    let state: String?
    let country: String?
    let jobTitle: String?
    let company: String?
    let field: Field?
    let degree: String?
    let aboutMe: String?
    let userPhotos: [Photo]?
    let languages: [String]?
}
