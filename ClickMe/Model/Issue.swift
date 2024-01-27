//
//  Issue.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-26.
//

import Foundation

struct Issue: Codable, Identifiable {
    var id: String { return _id }
    
    var _id: String
    var createdDate: Date
    var userId: String
    var requestId: String
    var issueDetail: String
}
