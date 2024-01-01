//
//  GetStartedViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import Foundation
import SwiftUI

final class GetStartedViewModel: ObservableObject {
    @Published var tabSelection = 0
    @Published var shouldGoToNextScreen = false
    
    var getStartedSteps = GetStartedSteps.steps
    
    func goToNextSlide() {
        if (tabSelection < getStartedSteps.count - 1) {
            tabSelection = tabSelection + 1
        } else {
            shouldGoToNextScreen = true
            print("shouldGoToNextScreen: ", shouldGoToNextScreen)
        }
    }
}
