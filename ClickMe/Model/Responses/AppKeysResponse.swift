//
//  S3KeysResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct AppKeysResponse: Codable {
    let success: Bool
    let message: String
    let data: AppKeysData?
}

struct AppKeysData: Codable {
    let buckName: String
    let s3Key: String
    let s3AccessKey: String
    let agoraAppId: String
    let stripeRefreshUrl: String
    let stripeReturnUrl: String
}
