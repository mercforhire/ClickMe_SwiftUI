//
//  Message.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct Message: Codable, Identifiable, Equatable {
    var id: String { return _id }
    let _id: String
    let createdDate: Date
    let fromUserId: String
    let toUserId: String
    let message: String?
    let attachment: Attachment?
    
    var messageString: String {
        if !(message?.isEmpty ?? true) {
            return message ?? ""
        }
        return "This message contains a special action."
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs._id == rhs._id
    }
    
}
