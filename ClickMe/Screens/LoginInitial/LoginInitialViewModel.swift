//
//  LoginInitialViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import Foundation
import SwiftUI

final class LoginInitialViewModel: ObservableObject {
    @Published var shouldGoToLoginScreen = false
    @Published var shouldGoToSignUpScreen = false
    @Published var isPresentingTermsOfUse = false
    @Published var isPresentingPrivacy = false
}
