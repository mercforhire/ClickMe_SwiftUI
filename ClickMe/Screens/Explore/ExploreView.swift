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
    @State private var navigationPath: [ScreenNames] = []
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: ExploreViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List(viewModel.showUsers, id: \.self) { profile in
                    ExploreCell(profile: profile, imageHeight: 200)
                        .onTapGesture {
                            viewModel.selectedProfile = profile
                            viewModel.isShowingProfile = true
                        }
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .refreshable {
                    if !viewModel.searchIsActive {
                        fetchUsers(forceRefresh: true)
                    }
                }
                if viewModel.searchIsActive, viewModel.showUsers.isEmpty {
                    CMEmptyView()
                }
            }
            .navigationTitle("Explore")
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.following:
                    FollowingView(myProfile: viewModel.myProfile)
                default:
                    fatalError()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "person") {
                        navigationPath.append(.following)
                    }
                    .tint(Color.accentColor)
                    
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
            .popover(isPresented: $viewModel.isPresentingFilter) {
                ExploreFilterView(isPresentingFilter: $viewModel.isPresentingFilter)
                    .environmentObject(filterViewModel)
            }
            .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
                UserDetailsView(myProfile: viewModel.myProfile,
                                profile: viewModel.selectedProfile!,
                                isShowingProfile: $viewModel.isShowingProfile,
                                loadTopics: true)
            }
            .onChange(of: viewModel.searchText) { searchText in
                viewModel.searchUsers()
            }
            .onChange(of: viewModel.isPresentingFilter) { _ in
                if !viewModel.isPresentingFilter {
                    fetchUsers(forceRefresh: true)
                }
            }
        }
        .if(viewModel.searchIsActive) { navigationView in
            navigationView.searchable(text: $viewModel.searchText)
        }
        .onAppear() {
            fetchUsers(forceRefresh: false)
        }
    }
    
    func fetchUsers(forceRefresh: Bool) {
        viewModel.fetchUsers(filter: filterViewModel.toExploreUsersParams(), forceRefresh: forceRefresh)
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return ExploreView(myProfile: MockData.mockProfile())
}
