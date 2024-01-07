//
//  Attachment.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct Attachment: Codable {
    let action: String?
    let request: Request?
    let topic: Topic?
}
