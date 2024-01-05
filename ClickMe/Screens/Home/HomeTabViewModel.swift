//
//  HomeTabViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation
import SwiftUI

@MainActor
final class HomeTabViewModel: ObservableObject {
    @Published var shouldReturnToLogin = false
    @Published var shouldPresentSetupProfileFlow = false
    
    func checkProfileCompletion() {
        if UserManager.shared.profile?.firstName?.isEmpty ?? true {
            shouldPresentSetupProfileFlow = true
        }
    }
}
