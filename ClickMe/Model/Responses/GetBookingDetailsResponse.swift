//
//  GetBookingDetailsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import Foundation

struct GetBookingDetailsResponse: Codable {
    let success: Bool
    let message: String
    var data: GetBookingDetailsData?
}

struct GetBookingDetailsData: Codable {
    var request: Request
    var receipt: Receipt?
    var reviews: [Review]?
}
