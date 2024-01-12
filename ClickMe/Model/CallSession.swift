//
//  CallSession.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

struct CallSession: Codable, Identifiable {
    var id: String { return _id }
    
    let _id: String
    let createdDate: Date
    let requestId: String
    let token: String
    let expireTime: Date
    
}
