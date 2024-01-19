//
//  StripeAccount.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-18.
//

import Foundation

struct StripeAccount: Codable, Identifiable, Hashable {
    var id: String
    var object: String
    var charges_enabled: Bool
    var country: String
    var default_currency: String
    var email: String
    var payouts_enabled: Bool
    var type: String
}
