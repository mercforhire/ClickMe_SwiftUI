//
//  Attachment.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct Attachment: Codable, Hashable {
    let action: MessageAction
    let request: Request?
    let topic: Topic?
    
    static func == (lhs: Attachment, rhs: Attachment) -> Bool {
        return lhs.action == rhs.action && lhs.request == rhs.request && lhs.topic == rhs.topic
    }
}
