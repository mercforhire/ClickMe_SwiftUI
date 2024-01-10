//
//  Availability.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation

struct Timeslot: Codable, Identifiable {
    var id: Double { start.timeIntervalSince1970 + end.timeIntervalSince1970 }
    
    var start: Date
    var end: Date
    
    var timeAndDuration: String {
        let date = DateUtil.convert(input: start, outputFormat: .format15)!
        let startTime = DateUtil.convert(input: start, outputFormat: .format8)!
        let endTime = DateUtil.convert(input: end, outputFormat: .format8)!
        return "\(date), \(startTime) - \(endTime)"
    }
}
