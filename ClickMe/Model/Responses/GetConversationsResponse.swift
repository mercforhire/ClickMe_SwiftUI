//
//  GetConversationsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct GetConversationsResponse: Codable {
    let success: Bool
    let message: String
    var data: GetConversationsData?
}

struct GetConversationsData: Codable {
    var conversations: [Conversation]
}
