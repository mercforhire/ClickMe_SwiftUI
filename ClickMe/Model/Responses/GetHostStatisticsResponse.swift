//
//  GetHostStatisticsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import Foundation

struct GetHostStatisticsResponse: Codable {
    let success: Bool
    let message: String
    var data: GetHostStatisticsData?
}

struct GetHostStatisticsData: Codable {
    var totalEarnings: Int
    var totalHours: Int
    var numberOfReviews: Int
    var ratings: Double?
}
