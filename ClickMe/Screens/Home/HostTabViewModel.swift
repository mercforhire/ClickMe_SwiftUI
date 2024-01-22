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
    var myUser: User
    var myProfile: UserProfile
    
    @AppStorage("hasShownGetStartedScreen") var hasShownGetStartedScreen = false
    @Published var tabSelection: HostTabs = .upcoming
    @Published var talkTo: UserProfile?
    @Published var shouldPresentGetStartedView = false
    
    init(myUser: User, myProfile: UserProfile) {
        self.myUser = myUser
        self.myProfile = myProfile
        
        if !hasShownGetStartedScreen {
            shouldPresentGetStartedView = true
        }
    }
    
    func handleSwitchToChatNotification(notification: NotificationCenter.Publisher.Output) {
        if let user = notification.userInfo?["user"] as? UserProfile {
            talkTo = user
            tabSelection = .inbox
        }
    }
}
