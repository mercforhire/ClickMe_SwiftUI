//
//  SplashViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation
import SwiftUI

@MainActor
final class SplashViewModel: ObservableObject {
    @Published var appIsActive = false
    @Published var loginInProgress = false
    @Published var isLoggedIn = false
    @Published var callSession: CallSession?
    
    var user: User? {
        return UserManager.shared.user
    }
    
    var userProfile: UserProfile? {
        return UserManager.shared.profile
    }
    
    func prepareToLogin() {
        if let apiKey = UserManager.shared.apiKey {
            Task {
                loginInProgress = true
                let loginResponse = try? await ClickAPI.shared.loginUsingAPIKey(apiKey: apiKey)
                if let user = loginResponse?.data?.user, let profile = loginResponse?.data?.profile {
                    UserManager.shared.set(user: user, profile: profile)
                    await UserManager.shared.fetchAppKeys()
                    isLoggedIn = true
                } else {
                    logOut()
                }
                loginInProgress = false
            }
        }
    }
    
    func startSplashCountdown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.appIsActive = true
            }
        }
    }
    
    func handleRefreshLoginStatus() {
        isLoggedIn = UserManager.shared.isLoggedIn()
    }
    
    func logOut() {
        UserManager.shared.logout()
    }
    
    func handleJoinACall(notification: NotificationCenter.Publisher.Output) {
        if let session = notification.userInfo?["session"] as? CallSession {
            callSession = session
        }
    }
}
