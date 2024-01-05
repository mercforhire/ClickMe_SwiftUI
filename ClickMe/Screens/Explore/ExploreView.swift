//
//  ExploreView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()
    @StateObject var filterViewModel = ExploreFilterViewModel()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 40
    private var cellWidth: CGFloat {
        return screenWidth - padding * 2
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.searchIsActive ? viewModel.searchResults : viewModel.profiles, id: \.id) { profile in
                    ExploreCell(profile: profile, imageWidth: cellWidth, imageHeight: 200)
                        .onTapGesture {
                            viewModel.selectedProfile = profile
                            viewModel.isShowingProfile = true
                        }
                }
                .navigationTitle("Explore")
                .listStyle(.plain)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button("", systemImage: "gearshape") {
                            viewModel.isPresentingFilter = true
                        }
                        Button("", systemImage: "magnifyingglass") {
                            viewModel.toggleSearchIsActive()
                        }
                    }
                }
                if viewModel.searchIsActive, viewModel.searchResults.isEmpty {
                    CMEmptyView()
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
        .if(viewModel.searchIsActive) { navigationView in
            navigationView.searchable(text: $viewModel.searchText)
        }
        .onChange(of: viewModel.searchText) { searchText in
            viewModel.searchUsers()
        }
        .popover(isPresented: $viewModel.isPresentingFilter) {
            ExploreFilterView(isPresentingFilter: $viewModel.isPresentingFilter)
                .environmentObject(filterViewModel)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            if let selectedProfile = viewModel.selectedProfile {
                UserDetailsView(profile: selectedProfile,
                                isShowingProfile: $viewModel.isShowingProfile)
            }
        }
        .onAppear() {
            viewModel.fetchUsers(filter: filterViewModel.toExploreUsersParams())
        }
        .onChange(of: filterViewModel.fields) { _ in
            viewModel.fetchUsers(filter: filterViewModel.toExploreUsersParams())
        }
        .onChange(of: filterViewModel.languages) { _ in
            viewModel.fetchUsers(filter: filterViewModel.toExploreUsersParams())
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return ExploreView()
}
