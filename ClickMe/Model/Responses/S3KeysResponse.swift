//
//  S3KeysResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

struct S3KeysResponse: Codable {
    let success: Bool
    let message: String
    let data: S3KeysData?
}

struct S3KeysData: Codable {
    let buckName: String?
    let s3Key: String?
    let s3AccessKey: String?
}
