//
//  HomeTabView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject var viewModel = HomeTabViewModel()
    
    var body: some View {
        if viewModel.shouldReturnToLogin {
            LoginInitialView()
        } else {
            TabView {
                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "globe")
                    }
                FollowingsView()
                    .tabItem {
                        Label("Following", systemImage: "person.line.dotted.person")
                    }
                MyBookingsView()
                    .tabItem {
                        Label("Bookings", systemImage: "calendar.badge.clock")
                    }
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person")
                    }
            }
            .onAppear {
//                viewModel.checkProfileCompletion()
            }
            .fullScreenCover(isPresented: $viewModel.shouldPresentSetupProfileFlow) {
                SetupBasicInfoView(shouldReturnToLogin: $viewModel.shouldReturnToLogin,
                                   shouldPresentSetupProfileFlow: $viewModel.shouldPresentSetupProfileFlow)
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return HomeTabView()
}
