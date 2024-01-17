//
//  LoginInitialViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import Foundation
import SwiftUI

final class LoginInitialViewModel: ObservableObject {
    @Published var isPresentingTermsOfUse = false
    @Published var isPresentingPrivacy = false
    
    var userProfile: UserProfile? {
        return UserManager.shared.profile
    }
}
