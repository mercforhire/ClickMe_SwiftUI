//
//  ReceiptsResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-19.
//

import Foundation

struct ReceiptsResponse: Codable {
    let success: Bool
    let message: String
    var data: ReceiptsData?
}

struct ReceiptsData: Codable {
    var receipts: [Receipt]
}
