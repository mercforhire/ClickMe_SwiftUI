//
//  Request.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct Request: Codable, Identifiable {
    var id: String { return _id }
    
    let _id: String
    let createdDate: Date
    let bookingUserId: String
    var bookingUser: UserProfile
    let hostUserId: String
    var hostUser: UserProfile
    let topicId: String
    var topic: Topic
    let startTime: Date
    let endTime: Date
    let status: RequestStatus
    
    var timeAndDuration: String {
        let date = DateUtil.convert(input: startTime, outputFormat: .format11)!
        let startTime = DateUtil.convert(input: startTime, outputFormat: .format8)!
        let endTime = DateUtil.convert(input: endTime, outputFormat: .format8)!
        return "\(date), \(startTime) - \(endTime)"
    }
}
