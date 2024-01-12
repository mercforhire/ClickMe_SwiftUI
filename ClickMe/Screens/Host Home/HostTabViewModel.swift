//
//  HostTabViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation
import SwiftUI

@MainActor
final class HostTabViewModel: ObservableObject {
    @Published var tabSelection: HostTabs = .inbox
    @Published var talkTo: UserProfile?
    @Published var shouldPresentGetStartedView = false
    
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
