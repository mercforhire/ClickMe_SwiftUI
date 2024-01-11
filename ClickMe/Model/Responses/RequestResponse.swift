//
//  RequestResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation

struct RequestResponse: Codable {
    let success: Bool
    let message: String
    var data: RequestData?
}

struct RequestData: Codable {
    var request: Request?
    var stripeData: StripeData?
    var receipt: Receipt?
}
