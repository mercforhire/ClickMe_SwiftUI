//
//  TopicsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation

struct TopicsResponse: Codable {
    let success: Bool
    let message: String
    var data: TopicsData?
}

struct TopicsData: Codable {
    var topics: [Topic]?
}
