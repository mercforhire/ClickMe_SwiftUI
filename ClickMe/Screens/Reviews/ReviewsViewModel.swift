//
//  ReviewsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import Foundation
import SwiftUI

@MainActor
final class ReviewsViewModel: ObservableObject {
    var user: UserProfile
    
    @Published var isLoading = false
    @Published var reviews: [Review] = []
    
    init(user: UserProfile) {
        self.user = user
    }
    
    func fetchData() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getReviewsByUser(userId: user.userId)
            if let reviews = response?.data?.reviews {
                self.reviews = reviews
            }
            isLoading = false
        }
    }
}
