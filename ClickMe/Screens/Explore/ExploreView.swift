//
//  ExploreView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel: ExploreViewModel
    @StateObject var filterViewModel = ExploreFilterViewModel()
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: ExploreViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.showUsers, id: \.id) { profile in
                    ExploreCell(profile: profile, imageHeight: 200)
                        .onTapGesture {
                            viewModel.selectedProfile = profile
                            viewModel.isShowingProfile = true
                        }
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button("", systemImage: viewModel.followingButtonImageName) {
                            viewModel.isShowingFollowing.toggle()
                        }
                        .tint(viewModel.isShowingFollowing ? Color.red : Color.accentColor)
                        
                        Button("", systemImage: filterViewModel.filterButtonImageName) {
                            viewModel.isPresentingFilter = true
                        }
                        .tint(filterViewModel.hasFilters ? Color.red : Color.accentColor)
                        
                        Button("", systemImage: "magnifyingglass") {
                            viewModel.toggleSearchIsActive()
                        }
                        .tint(viewModel.searchIsActive ? Color.red : Color.accentColor)
                    }
                }
                .refreshable {
                    if !viewModel.searchIsActive {
                        viewModel.fetchUsers(filter: filterViewModel.toExploreUsersParams())
                    }
                }
                if viewModel.searchIsActive, viewModel.showUsers.isEmpty {
                    CMEmptyView()
                }
            }
            .navigationTitle(viewModel.isShowingFollowing ? "Following" : "Explore")
        }
        .if(viewModel.searchIsActive) { navigationView in
            navigationView.searchable(text: $viewModel.searchText)
        }
        .popover(isPresented: $viewModel.isPresentingFilter) {
            ExploreFilterView(isPresentingFilter: $viewModel.isPresentingFilter)
                .environmentObject(filterViewModel)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(profile: viewModel.selectedProfile!,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: true)
        }
        .onAppear() {
            fetchUsers()
        }
        .onChange(of: viewModel.searchText) { searchText in
            viewModel.searchUsers()
        }
        .onChange(of: filterViewModel.fields) { _ in
            fetchUsers()
        }
        .onChange(of: filterViewModel.languages) { _ in
            fetchUsers()
        }
    }
    
    func fetchUsers() {
        viewModel.fetchUsers(filter: filterViewModel.toExploreUsersParams())
        viewModel.fetchFollowingUsers()
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return ExploreView(myProfile: MockData.mockProfile())
}
