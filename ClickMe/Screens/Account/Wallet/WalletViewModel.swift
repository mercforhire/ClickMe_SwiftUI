//
//  WalletViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-18.
//

import Foundation

@MainActor
final class WalletViewModel: ObservableObject {
    var myProfile: UserProfile
    
    @Published var isLoading = false
    @Published var statistics: GetHostStatisticsData?
    
    @Published var receipts: [Receipt] = []
    @Published var upcoming: [Receipt] = []
    @Published var paid: [Receipt] = []
    
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
            
            let response2 = try? await ClickAPI.shared.getHostBookingReceipts()
            if let receipts = response2?.data?.receipts {
                self.receipts = receipts
                sortReceipts()
            } else {
                receipts.removeAll()
                upcoming.removeAll()
                paid.removeAll()
            }
            isLoading = false
        }
    }
    
    func sortReceipts() {
        upcoming = receipts.filter({ receipt in
            receipt.status == .AUTHORIZED || receipt.status == .PAID
        })
        upcoming.sort { left, right in
            left.statusChangeDate > right.statusChangeDate
        }
        
        paid = receipts.filter({ receipt in
            receipt.status == .PAID_OUT
        })
        paid.sort { left, right in
            left.statusChangeDate > right.statusChangeDate
        }
    }
}
