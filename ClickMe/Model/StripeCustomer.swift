//
//  StripeCustomer.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-20.
//

import Foundation

struct StripeCustomer: Codable, Identifiable, Hashable {
    var id: String
    var object: String
    var email: String
    var name: String
    var phone: String
}
