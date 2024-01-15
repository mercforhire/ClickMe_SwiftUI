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
    var myProfile: UserProfile
    
    @Published var shouldPresentSetupProfileFlow = false
    @Published var tabSelection: HomeTabs = .explore
    @Published var talkTo: UserProfile?
    @Published var isShowingCallView = false
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }
    
    func checkProfileCompletion() {
        if UserManager.shared.profile?.firstName?.isEmpty ?? true {
            shouldPresentSetupProfileFlow = true
        }
    }
    
    func handleSwitchToChatNotification(notification: NotificationCenter.Publisher.Output) {
        if let user = notification.userInfo?["user"] as? UserProfile {
            talkTo = user
            tabSelection = .inbox
        }
    }
}
