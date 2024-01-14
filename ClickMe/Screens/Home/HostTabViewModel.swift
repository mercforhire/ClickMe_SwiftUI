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
    var myProfile: UserProfile
    
    @Published var tabSelection: HostTabs = .upcoming
    @Published var talkTo: UserProfile?
    @Published var shouldPresentGetStartedView = false
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }
    
    func handleSwitchToChatNotification(notification: NotificationCenter.Publisher.Output) {
        if let user = notification.userInfo?["user"] as? UserProfile {
            talkTo = user
            tabSelection = .inbox
        }
    }
}
