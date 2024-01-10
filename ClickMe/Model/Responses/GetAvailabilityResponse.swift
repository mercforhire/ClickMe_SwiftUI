//
//  GetAvailabilityResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation

struct GetAvailabilityResponse: Codable {
    let success: Bool
    let message: String
    var data: GetAvailabilityData?
}

struct GetAvailabilityData: Codable {
    var timezone: String
    var timesAvailable: [Timeslot]
    var futureBookings: [Request]
}
