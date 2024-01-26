//
//  ClickMeApp.swift
//  ClickMe
//
//  Created by Leon Chen on 2023-12-31.
//

import SwiftUI

@main
struct ClickMeApp: App {
    @StateObject private var appRootManager = AppRootManager()
    @StateObject private var agora = AgoraManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .splash:
                    SplashView()
                case .authentication:
                    GetStartedView()
                case .homeGuest:
                    HostTabView(myUser: appRootManager.user,
                                myProfile: appRootManager.userProfile)
                    .environmentObject(agora)
                case .homeHost:
                    HomeTabView(myUser: appRootManager.user,
                                myProfile: appRootManager.userProfile)
                    .environmentObject(agora)
                }
            }
            .onAppear() {
                appRootManager.startSplashCountdown()
            }
            .fullScreenCover(isPresented: $agora.isPresentingCallScreen) {
                if let callSession = appRootManager.callSession {
                    CallingView(myProfile: appRootManager.userProfile,
                                talkingTo: callSession.callingUser,
                                topic: callSession.topic,
                                request: callSession.request,
                                isShowingCallScreen: $agora.isPresentingCallScreen)
                    .environmentObject(agora)
                }
            }
            .onChange(of: appRootManager.callSession) { callSession in
                if let callSession = callSession, let agoraAppId = UserManager.shared.agoraAppId {
                    agora.initializeAgora(appId: agoraAppId)
                    Task {
                        await agora.joinChannel(callingUser: callSession.callingUser,
                                                request: callSession.request,
                                                topic: callSession.topic,
                                                token: callSession.token)
                        await agora.sendJoinSessionAction()
                        agora.isPresentingCallScreen = true
                    }
                }
            }
            .onChange(of: appRootManager.isLoggedIn) { isLoggedIn in
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
                } else if agora.joiningChannel {
                    LoadingView()
                }
            }
        }
    }
}
