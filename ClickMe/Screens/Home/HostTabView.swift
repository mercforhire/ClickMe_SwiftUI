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
    
    init(myUser: User, myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: HostTabViewModel(myUser: myUser, myProfile: myProfile))
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
            
            HostAccountView(myUser: viewModel.myUser, myProfile: viewModel.myProfile)
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(HostTabs.account)
                .environmentObject(agora)
        }
        .fullScreenCover(isPresented: $viewModel.shouldPresentGetStartedView) {
            HostGetStartedView(isShowingGetStarted: $viewModel.shouldPresentGetStartedView)
        }
    }
}

#Preview {
    UserManager.shared.set(user: MockData.mockUser2(), profile: MockData.mockProfile2())
    
    return HostTabView(myUser: MockData.mockUser2(), myProfile: MockData.mockProfile2())
        .environmentObject({() -> AgoraManager in
            let agora = AgoraManager()
            return agora
        }())
}
