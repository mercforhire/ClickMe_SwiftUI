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
    
    var totalEarningsDisplayable: String {
        let dollarAmount: Double = Double(totalEarnings) / 100.0
        return "$\(String(format: "%.2f", dollarAmount))"
    }
    
    var ratingDisplayable: String {
        guard let ratings else { return "--" }
        
        return String(format: "%.1f", ratings)
    }
}
