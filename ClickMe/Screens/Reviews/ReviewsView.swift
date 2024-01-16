//
//  ReviewsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import SwiftUI

struct ReviewsView: View {
    @StateObject var viewModel: ReviewsViewModel
    
    init(user: UserProfile) {
        _viewModel = StateObject(wrappedValue: ReviewsViewModel(user: user))
    }
    
    var body: some View {
        ZStack {
            List(viewModel.reviews, id: \.self) { review in
                ReviewCell(review: review)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.fetchData()
            }
            if viewModel.reviews.isEmpty {
                CMEmptyView(imageName: "empty", message: "No reviews")
            }
        }
        .navigationTitle("\(viewModel.user.firstName ?? "")'s reviews")
        .onAppear() {
            viewModel.fetchData()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    return NavigationView {
        ReviewsView(user: MockData.mockProfile2())
    }
}
