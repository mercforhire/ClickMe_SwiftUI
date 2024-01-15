//
//  HomeTabView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI

enum HomeTabs: Hashable {
    case explore
    case topics
    case bookings
    case inbox
    case account
}

struct HomeTabView: View {
    @StateObject var viewModel: HomeTabViewModel
    @EnvironmentObject var agora: AgoraManager
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: HomeTabViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
            ExploreView(myProfile: viewModel.myProfile)
                .tabItem {
                    Label("Explore", systemImage: "globe")
                }
                .tag(HomeTabs.explore)
            ExploreTopicsView(openTopic: $viewModel.openTopic)
                .tabItem {
                    Label("Topics", systemImage: "lightbulb")
                }
                .tag(HomeTabs.topics)
            MyBookingsView(myProfile: viewModel.myProfile)
                .tabItem {
                    Label("Bookings", systemImage: "calendar.badge.clock")
                }
                .tag(HomeTabs.bookings)
            InboxView(myProfile: viewModel.myProfile, talkTo: $viewModel.talkTo)
                .tabItem {
                    Label("Inbox", systemImage: "bubble.left.and.text.bubble.right")
                }
                .tag(HomeTabs.inbox)
            AccountView(myProfile: viewModel.myProfile)
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(HomeTabs.account)
                .environmentObject(agora)
        }
        .onAppear {
            viewModel.checkProfileCompletion()
        }
        .fullScreenCover(isPresented: $viewModel.shouldPresentSetupProfileFlow) {
            SetupBasicInfoView(shouldPresentSetupProfileFlow: $viewModel.shouldPresentSetupProfileFlow)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notifications.SwitchToChat)) { notification in
            viewModel.handleSwitchToChatNotification(notification: notification)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notifications.SwitchToTopic)) { notification in
            viewModel.handleSwitchToTopicNotification(notification: notification)
        }
    }
}

#Preview {
    UserManager.shared.set(user: MockData.mockUser(), profile: MockData.mockProfile())
    
    return HomeTabView(myProfile: MockData.mockProfile())
        .environmentObject({() -> AgoraManager in
            let agora = AgoraManager()
            return agora
        }())
}
