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
    @StateObject var viewModel = HomeTabViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
            ExploreView(myProfile: viewModel.getCurrentUser())
                .tabItem {
                    Label("Explore", systemImage: "globe")
                }
                .tag(HomeTabs.explore)
            ExploreTopicsView()
                .tabItem {
                    Label("Topics", systemImage: "lightbulb")
                }
                .tag(HomeTabs.topics)
            MyBookingsView(myProfile: viewModel.getCurrentUser())
                .tabItem {
                    Label("Bookings", systemImage: "calendar.badge.clock")
                }
                .tag(HomeTabs.bookings)
            InboxView(myProfile: viewModel.getCurrentUser(), talkTo: $viewModel.talkTo)
                .tabItem {
                    Label("Inbox", systemImage: "bubble.left.and.text.bubble.right")
                }
                .tag(HomeTabs.inbox)
            AccountView(myProfile: viewModel.getCurrentUser())
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(HomeTabs.account)
        }
        .onAppear {
//                viewModel.checkProfileCompletion()
        }
        .fullScreenCover(isPresented: $viewModel.shouldPresentSetupProfileFlow) {
            SetupBasicInfoView(shouldPresentSetupProfileFlow: $viewModel.shouldPresentSetupProfileFlow)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notifications.SwitchToChat), perform: { notification in
            viewModel.handleSwitchToChatNotification(notification: notification)
        })
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return HomeTabView()
}
