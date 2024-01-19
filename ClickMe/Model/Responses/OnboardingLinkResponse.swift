//
//  OnboardingLinkResponse.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-18.
//

import Foundation

struct OnboardingLinkResponse: Codable {
    let success: Bool
    let message: String
    var data: OnboardingLinkData?
}

struct OnboardingLinkData: Codable {
    var accountLink: AccountLink
}
