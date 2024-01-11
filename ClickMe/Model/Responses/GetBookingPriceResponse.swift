//
//  GetBookingPriceResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation

struct GetBookingPriceResponse: Codable {
    let success: Bool
    let message: String
    var data: GetBookingPriceData?
}

struct GetBookingPriceData: Codable {
    var currency: Currency
    var amount: Double
}
