//
//  ReceiptDetailsViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-19.
//

import Foundation

@MainActor
final class ReceiptDetailsViewModel: ObservableObject {
    var myProfile: UserProfile
    var receipt: Receipt
    var topic: Topic {
        receipt.topic!
    }
    var request: Request {
        receipt.request!
    }
    var bookingUser: UserProfile {
        receipt.bookingUser!
    }
    @Published var isShowingProfile = false
    
    init(myProfile: UserProfile, receipt: Receipt) {
        self.myProfile = myProfile
        self.receipt = receipt
    }
}
