//
//  CMError.swift
//  Appetizers
//
//  Created by Leon Chen on 2023-11-26.
//

import Foundation

enum CMError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case sendCodeToEmailCalledTooFrequently
    case emailAlreadyTaken
    case verifyCodeInvalid
    case userDeletedAccount
    case userDoesntExist
    case invalidApiKey
    case s3UploadFailed
    case s3DeleteFailed
    case topicDoesntExist
    case chatBlocked
    case requestDoesntExist
}
