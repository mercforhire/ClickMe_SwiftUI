//
//  SplashView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct SplashView: View {
    @AppStorage("startinHostMode") private var startinHostMode = false
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.appIsActive && !viewModel.loginInProgress {
                if viewModel.loggedIn, let userProfile = viewModel.userProfile {
                    if startinHostMode {
                        HostTabView(myProfile: userProfile)
                    } else {
                        HomeTabView(myProfile: userProfile)
                    }
                } else {
                    GetStartedView()
                }
            } else {
                Image("background", bundle: nil)
                    .resizable()
                    .ignoresSafeArea()
                Image("logo2", bundle: nil)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
            }
        }
        .onAppear {
            viewModel.prepareToLogin()
            viewModel.startSplashCountdown()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notifications.SwitchToGetStarted), perform: { _ in
            viewModel.handleSwitchToGetStartedNotification()
        })
        .onReceive(NotificationCenter.default.publisher(for: Notifications.ToggleGuestHostMode), perform: { _ in
            startinHostMode.toggle()
        })
    }
}

#Preview {
    UserManager.shared.logout()
    
    return SplashView()
}
