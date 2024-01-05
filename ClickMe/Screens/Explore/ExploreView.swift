//
//  ExploreView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 40
    private var cellWidth: CGFloat {
        return screenWidth - padding * 2
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.profiles, id: \.id) { profile in
                ExploreCell(profile: profile, imageWidth: cellWidth, imageHeight: 200)
            }
            .navigationTitle("Explore users")
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
        }
        .if(viewModel.searchIsActive) { navigationView in
            navigationView.searchable(text: $viewModel.searchText)
        }
        .popover(isPresented: $viewModel.isPresentingFilter) {
            ExploreFilterView(isPresentingFilter: $viewModel.isPresentingFilter,
                              viewModel: $viewModel.filterViewModel)
        }
        .task(id: viewModel.filterViewModel) {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return ExploreView()
}
