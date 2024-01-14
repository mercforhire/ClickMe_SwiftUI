//
//  HostStatusViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import Foundation

@MainActor
final class HostStatusViewModel: ObservableObject {
    var myProfile: UserProfile
    
    @Published var isLoading = false
    @Published var statistics: GetHostStatisticsData?
    
    var totalEarnings: String {
        guard let amount = statistics?.totalEarnings else { return "$0" }
        
        let dollarAmount: Double = Double(amount) / 100.0
        return "$\(String(format: "%.2f", dollarAmount))"
    }
    
    var overallRating: String {
        guard let rating = statistics?.ratings else { return "--" }
        
        return String(format: "%.1f", rating)
    }
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }
    
    func fetchData() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getHostStatistics()
            if let statistics = response?.data {
                self.statistics = statistics
            }
            isLoading = false
        }
    }
}
