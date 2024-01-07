//
//  GetChatMessagesResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import Foundation

struct GetChatMessagesResponse: Codable {
    let success: Bool
    let message: String
    var data: GetChatMessagesData?
}

struct GetChatMessagesData: Codable {
    var messages: [Message]
    var particiantProfiles: [UserProfile]
}
