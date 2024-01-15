//
//  FollowingView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-15.
//

import SwiftUI

struct FollowingView: View {
    @StateObject var viewModel: FollowingViewModel
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: FollowingViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        ZStack {
            List(viewModel.profiles, id: \.id) { profile in
                ExploreCell(profile: profile, imageHeight: 200)
                    .onTapGesture {
                        viewModel.selectedProfile = profile
                        viewModel.isShowingProfile = true
                    }
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.fetchFollowingUsers()
            }
            if viewModel.profiles.isEmpty {
                CMEmptyView(imageName: "sad",message: "Not following anyone")
            }
        }
        .navigationTitle("Following")
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(myProfile: viewModel.myProfile,
                            profile: viewModel.selectedProfile!,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: true)
        }
        .onAppear() {
            viewModel.fetchFollowingUsers()
        }
    }
}

#Preview {
    FollowingView(myProfile: MockData.mockProfile())
}
