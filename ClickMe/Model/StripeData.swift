//
//  StripeData.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation

struct StripeData: Codable, Identifiable, Hashable {
    var id: String { return paymentIntentId }
    
    var paymentIntentId: String
    var stripeCustomerId: String
    var ephemeralKey: String
    var paymentIntentClientKey: String
    var publishableKey: String
}
