//
//  UserManager.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation
import Valet

class UserManager {
    static let shared = UserManager()
    private let myValet = Valet.valet(with: Identifier(nonEmpty: "ClickMe")!, accessibility: .whenUnlocked)
    
    var user: User?
    var profile: UserProfile?
    var apiKey: String? {
        return api.apiKey
    }
    
    private var api: ClickAPI {
        return ClickAPI.shared
    }
    
    init() {
        if let apiKey = try? myValet.string(forKey: "apiKey") {
            api.apiKey = apiKey
        }
    }
    
    func hasAPIKey() -> Bool {
        return api.apiKey != nil
    }
    
    func set(user: User, profile: UserProfile) {
        self.user = user
        self.profile = profile
        api.apiKey = user.apiKey
        saveAPIKey()
    }
    
    func logout() {
        self.user = nil
        self.profile = nil
        api.apiKey = nil
        saveAPIKey()
    }
    
    func isLoggedIn() -> Bool {
        return user != nil && profile != nil
    }
    
    func saveAPIKey() {
        if let apiKey = user?.apiKey {
            try? myValet.setString(apiKey, forKey: "apiKey")
        } else {
            try? myValet.removeObject(forKey: "apiKey")
        }
    }
}
