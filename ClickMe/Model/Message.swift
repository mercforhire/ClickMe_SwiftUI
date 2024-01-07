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
    
    static func mockShortMessage() -> Message {
        return Message(_id: "6599a83d5c1c5add1b703cb9", createdDate: Date(timeIntervalSince1970: 1704568600444 / 1000), fromUserId: "65971589d4f4d7af9f97a3bc", toUserId: "65971717d4f4d7af9f97d93b", message: "Hi Madaline", attachment: nil)
    }
    
    static func mockLongMessage() -> Message {
        return Message(_id: "6599a83d5c1c5add1b703cb9",
                       createdDate: Date(timeIntervalSince1970: 1704568600444 / 1000),
                       fromUserId: "65971589d4f4d7af9f97a3bc",
                       toUserId: "65971717d4f4d7af9f97d93b", 
                       message: "Paragraphs are the building blocks of papers. Many students define paragraphs in terms of length: a paragraph is a group of at least five sentences, a paragraph is half a page long, etc. In reality, though, the unity and coherence of ideas among sentences is what constitutes a paragraph. A paragraph is defined as “a group of sentences or a single sentence that forms a unit” (Lunsford and Connors 116). Length and appearance do not determine whether a section in a paper is a paragraph. For instance, in some styles of writing, particularly journalistic styles, a paragraph can be just one sentence long. Ultimately, a paragraph is a sentence or group of sentences that support one main idea. In this handout, we will refer to this as the “controlling idea,” because it controls what happens in the rest of the paragraph.",
                       attachment: nil)
    }
}
