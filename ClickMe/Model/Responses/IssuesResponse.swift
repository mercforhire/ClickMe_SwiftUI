//
//  IssuesResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-26.
//

import Foundation

struct IssuesResponse: Codable {
    let success: Bool
    let message: String
    var data: IssuesData?
}

struct IssuesData: Codable {
    var issues: [Issue]
}
