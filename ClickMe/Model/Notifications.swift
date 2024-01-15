//
//  Notifications.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import Foundation

class Notifications {
    static let SwitchToChat: Notification.Name = Notification.Name("SwitchToChat")
    static let SwitchToGetStarted: Notification.Name = Notification.Name("SwitchToGetStarted")
    static let RefreshProfile: Notification.Name = Notification.Name("RefreshProfile")
    static let ToggleGuestHostMode: Notification.Name = Notification.Name("ToggleGuestHostMode")
    static let APIKeyInvalid: Notification.Name = Notification.Name("APIKeyInvalid")
    static let RefreshMyTopics: Notification.Name = Notification.Name("RefreshMyTopics")
    static let RefreshBookingRequest: Notification.Name = Notification.Name("RefreshBookingRequest")
    static let SwitchToTopic: Notification.Name = Notification.Name("SwitchToTopic")
    static let JoinACall: Notification.Name = Notification.Name("JoinACall")
}
