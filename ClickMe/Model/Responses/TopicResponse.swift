//
//  TopicResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation

struct TopicResponse: Codable {
    let success: Bool
    let message: String
    var data: TopicData?
}

struct TopicData: Codable {
    var topic: Topic?
}
