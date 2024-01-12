//
//  StartCallSessionResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

struct StartCallSessionResponse: Codable {
    let success: Bool
    let message: String
    var data: StartCallSessionData?
}

struct StartCallSessionData: Codable {
    var token: String?
    var request: Request?
    var session: CallSession?
}
