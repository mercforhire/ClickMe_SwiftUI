//
//  SplashView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.appIsActive && !viewModel.loginInProgress {
                if viewModel.loggedIn {
                    HomeTabView()
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
//            UserManager.shared.logout()
            viewModel.prepareToLogin()
            viewModel.startSplashCountdown()
        }
    }
}

#Preview {
    SplashView()
}
