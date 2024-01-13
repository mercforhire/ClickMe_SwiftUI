//
//  GetUserRatingsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

struct GetUserRatingsResponse: Codable {
    let success: Bool
    let message: String
    var data: GetUserRatingsData?
}

struct GetUserRatingsData: Codable {
    var avgRatings: Double
}
