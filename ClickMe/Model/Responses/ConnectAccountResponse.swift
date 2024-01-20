//
//  ConnectAccountResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-18.
//

import Foundation

struct ConnectAccountResponse: Codable {
    let success: Bool
    let message: String
    var data: ConnectAccountData?
}

struct ConnectAccountData: Codable {
    var account: StripeAccount
}
