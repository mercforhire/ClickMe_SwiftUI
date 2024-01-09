//
//  HomeTabViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation
import SwiftUI

@MainActor
final class HomeTabViewModel: ObservableObject {
    @Published var shouldPresentSetupProfileFlow = false
    @Published var tabSelection: HomeTabs = .explore
    @Published var talkTo: UserProfile?
    
    func checkProfileCompletion() {
        if UserManager.shared.profile?.firstName?.isEmpty ?? true {
            shouldPresentSetupProfileFlow = true
        }
    }
    
    func getCurrentUser() -> UserProfile {
        return UserManager.shared.profile!
    }
    
    func handleSwitchToChatNotification(notification: NotificationCenter.Publisher.Output) {
        if let user = notification.userInfo?["user"] as? UserProfile {
            talkTo = user
            tabSelection = .inbox
        }
    }
}
