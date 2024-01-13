//
//  GetReviewsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

struct GetReviewsResponse: Codable {
    let success: Bool
    let message: String
    var data: GetReviewsData?
}

struct GetReviewsData: Codable {
    var reviews: [Review]
}
