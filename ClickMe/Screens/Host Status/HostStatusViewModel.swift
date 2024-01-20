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
