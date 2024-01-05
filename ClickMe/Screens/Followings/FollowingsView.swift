//
//  FollowingsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import SwiftUI

struct FollowingsView: View {
    @StateObject var viewModel = FollowingsViewModel()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 40
    private var cellWidth: CGFloat {
        return screenWidth - padding * 2
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.profiles, id: \.id) { profile in
                    ExploreCell(profile: profile, imageWidth: cellWidth, imageHeight: 200)
                        .onTapGesture {
                            viewModel.selectedProfile = profile
                            viewModel.isShowingProfile = true
                        }
                }
                .navigationTitle("Following")
                .listStyle(.plain)
                if viewModel.profiles.isEmpty {
                    CMEmptyView(message: "Not following anybody yet")
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("navLogo", bundle: nil)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.accentColor)
                        .padding(.leading, -100)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            if let selectedProfile = viewModel.selectedProfile {
                UserDetailsView(profile: selectedProfile,
                                isShowingProfile: $viewModel.isShowingProfile)
            }
        }
        .onAppear() {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    FollowingsView()
}
