//
//  Request.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct Request: Codable {
    let _id: String
    let createdDate: Date
    let bookingUserId: String
    let hostUserId: String
    let topicId: String
    let startTime: Date
    let endTime: Date
    let status: String
}
