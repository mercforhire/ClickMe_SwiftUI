//
//  SplashViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation
import SwiftUI

@MainActor
final class SplashViewModel: ObservableObject {
    @Published var appIsActive = false
    
    func startSplashCountdown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.appIsActive = true
            }
        }
    }
}
