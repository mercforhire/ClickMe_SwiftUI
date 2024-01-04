//
//  HomeView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        if viewModel.shouldReturnToLogin {
            LoginInitialView()
        } else {
            Text("Home screen")
                .onAppear {
                    viewModel.checkProfileCompletion()
                }
                .fullScreenCover(isPresented: $viewModel.shouldPresentSetupProfileFlow) {
                    SetupBasicInfoView(shouldReturnToLogin: $viewModel.shouldReturnToLogin,
                                       shouldPresentSetupProfileFlow: $viewModel.shouldPresentSetupProfileFlow)
                }
        }
    }
}

#Preview {
    HomeView()
}
