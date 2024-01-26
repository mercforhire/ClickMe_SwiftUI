//
//  HomeTabViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeTabViewModel: ObservableObject {
    var myUser: User
    var myProfile: UserProfile
    
    @Published var shouldPresentSetupProfileFlow = false
    @Published var tabSelection: HomeTabs = .explore
    @Published var talkTo: UserProfile?
    @Published var openTopic: Topic?
    
    var switchToChatNotification: AnyCancellable?
    var switchToTopicNotification: AnyCancellable?
    
    init(myUser: User, myProfile: UserProfile) {
        self.myUser = myUser
        self.myProfile = myProfile
        
        switchToChatNotification = NotificationCenter.default
            .publisher(for: Notifications.SwitchToChat)
            .sink(receiveValue: handleSwitchToChatNotification)
        
        switchToTopicNotification = NotificationCenter.default
            .publisher(for: Notifications.SwitchToTopic)
            .sink(receiveValue: handleSwitchToTopicNotification)
    }
    
    deinit {
        switchToChatNotification?.cancel()
        switchToTopicNotification?.cancel()
    }
    
    func checkProfileCompletion() {
        if myProfile.firstName?.isEmpty ?? true {
            shouldPresentSetupProfileFlow = true
        }
    }
    
    func handleSwitchToChatNotification(_ notification: NotificationCenter.Publisher.Output) {
        if let user = notification.userInfo?["user"] as? UserProfile {
            talkTo = user
            tabSelection = .inbox
        }
    }
    
    func handleSwitchToTopicNotification(_ notification: NotificationCenter.Publisher.Output) {
        if let topic = notification.userInfo?["topic"] as? Topic {
            openTopic = topic
            tabSelection = .topics
        }
    }
}
