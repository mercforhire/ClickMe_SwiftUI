//
//  GetStripePaymentDetailsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-16.
//

import Foundation

struct GetStripePaymentDetailsResponse: Codable {
    let success: Bool
    let message: String
    var data: StripeData?
}
