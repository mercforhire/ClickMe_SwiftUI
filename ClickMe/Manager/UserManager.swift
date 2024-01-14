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
    var agoraAppId: String?
    
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
        fetchAppKeys()
    }
    
    func set(profile: UserProfile) {
        self.profile = profile
    }
    
    func fetchAppKeys() {
        Task {
            do {
                let response = try await api.getAppKeys()
                if let appKeys = response.data {
                    api.initializeS3(bucketName: appKeys.buckName,
                                     s3Key: appKeys.s3Key,
                                     accessKey: appKeys.s3AccessKey)
                    agoraAppId = appKeys.agoraAppId
                }
            } catch {
                print("getAppKeys error:", error)
            }
        }
    }
    
    func logout() {
        self.user = nil
        self.profile = nil
        api.apiKey = nil
        saveAPIKey()
        UserDefaults.standard.resetDefaults()
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
