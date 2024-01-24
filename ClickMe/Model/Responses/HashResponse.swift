//
//  HashResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-24.
//

import Foundation

struct HashResponse: Codable {
    let success: Bool
    let message: String
    var data: HashData?
}

struct HashData: Codable {
    var hash: String?
}
