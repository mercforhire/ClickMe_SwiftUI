//
//  HostTabView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

enum HostTabs: Hashable {
    case inbox
    case calendar
    case topics
    case upcoming
    case account
}

struct HostTabView: View {
    @StateObject var viewModel = HostTabViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
            InboxView(myProfile: viewModel.getCurrentUser(), talkTo: $viewModel.talkTo)
                .tabItem {
                    Label("Inbox", systemImage: "bubble.left.and.text.bubble.right")
                }
                .tag(HostTabs.inbox)
            HostCalenderView(myUserId: viewModel.getCurrentUser().userId)
                .tabItem {
                    Label("Calender", systemImage: "clock")
                }
                .tag(HostTabs.calendar)
            HostUpcomingBookingsView(myUserId: viewModel.getCurrentUser().userId)
                .tabItem {
                    Label("Upcoming", systemImage: "calendar.badge.exclamationmark")
                }
                .tag(HostTabs.upcoming)
            HostTopicsView()
                .tabItem {
                    Label("Topics", systemImage: "lightbulb")
                }
                .tag(HostTabs.topics)
            AccountView(myProfile: viewModel.getCurrentUser())
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(HostTabs.account)
        }
        .onAppear {
            viewModel.shouldPresentGetStartedView = true
        }
        .fullScreenCover(isPresented: $viewModel.shouldPresentGetStartedView) {
            HostGetStartedView(isShowingGetStarted: $viewModel.shouldPresentGetStartedView)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notifications.SwitchToChat)) { notification in
            viewModel.handleSwitchToChatNotification(notification: notification)
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return HostTabView()
}
