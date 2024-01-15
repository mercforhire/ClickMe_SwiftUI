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
    @StateObject var agora = AgoraManager()
    
    var body: some View {
        ZStack {
            if viewModel.appIsActive && !viewModel.loginInProgress {
                if viewModel.isLoggedIn, let userProfile = viewModel.userProfile {
                    if startinHostMode {
                        HostTabView(myProfile: userProfile)
                            .environmentObject(agora)
                    } else {
                        HomeTabView(myProfile: userProfile)
                            .environmentObject(agora)
                    }
                } else {
                    GetStartedView()
                        .environmentObject(agora)
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
        .onReceive(NotificationCenter.default.publisher(for: Notifications.SwitchToGetStarted)) { _ in
            viewModel.handleSwitchToGetStartedNotification()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notifications.ToggleGuestHostMode)) { _ in
            startinHostMode.toggle()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notifications.JoinACall)) { notification in
            viewModel.handleJoinACall(notification: notification)
        }
        .fullScreenCover(isPresented: $agora.isPresentingCallScreen) {
            if let callSession = viewModel.callSession, 
                let myProfile = viewModel.userProfile {
                CallingView(myProfile: myProfile,
                            talkingTo: callSession.callingUser,
                            topic: callSession.topic,
                            request: callSession.request,
                            isShowingCallScreen: $agora.isPresentingCallScreen)
                .environmentObject(agora)
            }
        }
        .onChange(of: viewModel.callSession) { callSession in
            if let callSession = callSession, let agoraAppId = UserManager.shared.agoraAppId {
                agora.initializeAgora(appId: agoraAppId)
                Task {
                    await agora.joinChannel(callingUser: callSession.callingUser,
                                            request: callSession.request,
                                            topic: callSession.topic,
                                            token: callSession.token)
                    agora.isPresentingCallScreen = true
                }
            }
        }
        .onChange(of: viewModel.isLoggedIn) { isLoggedIn in
            if !isLoggedIn {
                agora.destroyAgoraEngine()
            }
        }
        .overlay(alignment: .bottom) {
            if agora.inInACall {
                Button(action: {
                    agora.isPresentingCallScreen = true
                }, label: {
                    CallingButtonView()
                })
                .padding([.bottom], 70)
            }
        }
    }
}

#Preview {
    UserManager.shared.logout()
    
    return SplashView()
}
