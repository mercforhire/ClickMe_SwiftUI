//
//  Conversation.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct Conversation: Codable, Identifiable {
    var id: String { return _id }
    
    let _id: String
    let createdDate: Date
    let participants: [UserProfile]
    let lastMessage: Message
    let lastMessageDate: Date
    
    
}
