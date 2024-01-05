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
    @Published var loggedIn = false
    
    func prepareToLogin() {
        if let apiKey = UserManager.shared.apiKey {
            Task {
                loginInProgress = true
                let loginResponse = try? await ClickAPI.shared.loginUsingAPIKey(apiKey: apiKey)
                if let user = loginResponse?.data?.user, let profile = loginResponse?.data?.profile {
                    UserManager.shared.set(user: user, profile: profile)
                    loggedIn = true
                } else {
                    logOut()
                }
                loginInProgress = false
            }
        }
    }
    
    func startSplashCountdown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                self.appIsActive = true
            }
        }
    }
    
    func logOut() {
        UserManager.shared.logout()
    }
}
