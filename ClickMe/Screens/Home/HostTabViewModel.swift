//
//  HostTabViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class HostTabViewModel: ObservableObject {
    var myUser: User
    var myProfile: UserProfile
    
    @AppStorage("hasShownGetStartedScreen") var hasShownGetStartedScreen: Bool = false
    @Published var tabSelection: HostTabs = .upcoming
    @Published var talkTo: UserProfile?
    @Published var shouldPresentGetStartedView = false
    
    var switchToChatNotification: AnyCancellable?
    
    init(myUser: User, myProfile: UserProfile) {
        self.myUser = myUser
        self.myProfile = myProfile
        
        if !hasShownGetStartedScreen {
            shouldPresentGetStartedView = true
        }
        
        switchToChatNotification = NotificationCenter.default
            .publisher(for: Notifications.SwitchToChat)
            .sink(receiveValue: handleSwitchToChatNotification)
    }
    
    deinit {
        switchToChatNotification?.cancel()
    }
    
    func handleSwitchToChatNotification(_ notification: NotificationCenter.Publisher.Output) {
        if let user = notification.userInfo?["user"] as? UserProfile {
            talkTo = user
            tabSelection = .inbox
        }
    }
}
