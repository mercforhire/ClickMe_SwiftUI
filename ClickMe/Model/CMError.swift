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
}
