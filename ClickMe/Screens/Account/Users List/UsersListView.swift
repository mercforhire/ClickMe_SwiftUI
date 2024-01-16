//
//  UsersListView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import SwiftUI

struct UsersListView: View {
    @StateObject var viewModel: UsersListViewModel
    
    init(myProfile: UserProfile, type: UsersListTypes) {
        _viewModel = StateObject(wrappedValue: UsersListViewModel(myProfile: myProfile, type: type))
    }
    
    var body: some View {
        ZStack {
            List(viewModel.users, id: \.self) { user in
                SimpleUserCell(profile: user)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        viewModel.selectedProfile = user
                        viewModel.isShowingProfile = true
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        switch viewModel.type {
                        case .following:
                            Button(role: .destructive) {
                                viewModel.unfollowUser(user: user)
                            } label: {
                                Label("Unfollow", systemImage: "person.fill.xmark")
                            }
                            
                        case .blockedUsers:
                            Button {
                                viewModel.unblockUser(user: user)
                            } label: {
                                Label("Unblock", systemImage: "person.fill.checkmark")
                            }
                            .tint(.green)
                            
                        default:
                            EmptyView()
                        }
                    }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.fetchUsers()
            }
            
            if viewModel.users.isEmpty {
                CMEmptyView(message: "No users")
            }
        }
        .navigationTitle(viewModel.type.title())
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(myProfile: viewModel.myProfile,
                            profile: viewModel.selectedProfile!,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: true)
        }
        .onAppear() {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return UsersListView(myProfile: MockData.mockProfile(), type: .following)
}
