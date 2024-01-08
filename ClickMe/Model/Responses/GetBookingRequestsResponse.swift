//
//  GetBookingRequestsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import Foundation

struct GetBookingRequestsResponse: Codable {
    let success: Bool
    let message: String
    var data: GetBookingRequestsData?
}

struct GetBookingRequestsData: Codable {
    var requests: [Request]
}
