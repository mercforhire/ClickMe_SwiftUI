//
//  SendChatMessageResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import Foundation

struct SendChatMessageResponse: Codable {
    let success: Bool
    let message: String
    var data: SendChatMessageData?
}

struct SendChatMessageData: Codable {
    var message: Message?
}
