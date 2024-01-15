//
//  CallSession.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

struct CallSession: Codable, Identifiable, Hashable {
    var id: String { return token }
    
    var token: String
    var callingUser: UserProfile
    var request: Request
    var topic: Topic
}
