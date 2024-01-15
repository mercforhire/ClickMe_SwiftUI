//
//  HostTabView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

enum HostTabs: Hashable {
    case inbox
    case topics
    case upcoming
    case status
    case account
}

struct HostTabView: View {
    @StateObject var viewModel: HostTabViewModel
    @EnvironmentObject var agora: AgoraManager
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: HostTabViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
            HostUpcomingBookingsView(myProfile: viewModel.myProfile)
                .tabItem {
                    Label("Upcoming", systemImage: "calendar.badge.exclamationmark")
                }
                .tag(HostTabs.upcoming)
            
            HostTopicsView(myProfile: viewModel.myProfile)
                .tabItem {
                    Label("Topics", systemImage: "lightbulb")
                }
                .tag(HostTabs.topics)
            
            InboxView(myProfile: viewModel.myProfile, talkTo: $viewModel.talkTo)
                .tabItem {
                    Label("Inbox", systemImage: "text.bubble")
                }
                .tag(HostTabs.inbox)
            
            HostStatusView(myProfile: viewModel.myProfile)
                .tabItem {
                    Label("Status", systemImage: "chart.bar")
                }
                .tag(HostTabs.status)
            
            HostAccountView(myProfile: viewModel.myProfile)
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(HostTabs.account)
                .environmentObject(agora)
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
    UserManager.shared.set(user: MockData.mockUser2(), profile: MockData.mockProfile2())
    
    return HostTabView(myProfile: MockData.mockProfile2())
        .environmentObject({() -> AgoraManager in
            let agora = AgoraManager()
            return agora
        }())
}
