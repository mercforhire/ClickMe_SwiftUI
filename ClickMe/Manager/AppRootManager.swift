//
//  AppRootManager.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-24.
//

import Foundation
import SwiftUI
import Combine

enum AppRoots {
    case splash
    case authentication
    case homeGuest
    case homeHost
}

@MainActor
final class AppRootManager: ObservableObject {
    @AppStorage("startinHostMode") var startinHostMode = false
    @Published var loginInProgress = false
    @Published var callSession: CallSession?
    @Published var currentRoot: AppRoots = .splash
    @Published var isLoggedIn = false
    
    var user: User {
        return UserManager.shared.user!
    }
    var userProfile: UserProfile {
        return UserManager.shared.profile!
    }
    var toggleGuestHostModeNotification: AnyCancellable?
    var refreshLoginStatusNotification: AnyCancellable?
    var joinACallNotification: AnyCancellable?
    
    init() {
        toggleGuestHostModeNotification = NotificationCenter.default
            .publisher(for: Notifications.ToggleGuestHostMode)
            .sink { notification in
                self.startinHostMode.toggle()
            }
        
        refreshLoginStatusNotification = NotificationCenter.default
            .publisher(for: Notifications.RefreshLoginStatus)
            .sink { notification in
                self.handleRefreshLoginStatus()
            }
        
        joinACallNotification  = NotificationCenter.default
            .publisher(for: Notifications.JoinACall)
            .sink { notification in
                self.handleJoinACall(notification: notification)
            }
    }
    
    deinit {
        toggleGuestHostModeNotification?.cancel()
        refreshLoginStatusNotification?.cancel()
        joinACallNotification?.cancel()
    }
    
    func handleRefreshLoginStatus() {
        if UserManager.shared.isLoggedIn() {
            if startinHostMode {
                currentRoot = .homeHost
            } else {
                currentRoot = .homeGuest
            }
            isLoggedIn = true
        } else {
            currentRoot = .authentication
            isLoggedIn = false
        }
    }
    
    func logOut() {
        UserManager.shared.logout()
        currentRoot = .authentication
    }
    
    func handleJoinACall(notification: NotificationCenter.Publisher.Output) {
        if let session = notification.userInfo?["session"] as? CallSession {
            callSession = session
        }
    }
    
    func prepareToLogin() {
        if let apiKey = UserManager.shared.apiKey {
            Task {
                let loginResponse = try? await ClickAPI.shared.loginUsingAPIKey(apiKey: apiKey)
                if let user = loginResponse?.data?.user, let profile = loginResponse?.data?.profile {
                    UserManager.shared.set(user: user, profile: profile)
                    await UserManager.shared.fetchAppKeys()
                    handleRefreshLoginStatus()
                } else {
                    logOut()
                }
            }
        } else {
            currentRoot = .authentication
        }
    }
    
    func startSplashCountdown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.prepareToLogin()
        }
    }
}
