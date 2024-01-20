//
//  ConnectAccountResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-18.
//

import Foundation

struct WalletDetailsResponse: Codable {
    let success: Bool
    let message: String
    var data: WalletData?
}

struct WalletData: Codable {
    var customer: StripeCustomer?
    var connectedAccount: StripeAccount?
}
