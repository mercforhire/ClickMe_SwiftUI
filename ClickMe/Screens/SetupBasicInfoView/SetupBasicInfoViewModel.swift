//
//  SetupProfileViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation
import SwiftUI

final class SetupBasicInfoViewModel: ObservableObject {
    @Published var firstName = "Leon"
    @Published var firstNameError: String? = "test error"
    @Published var lastName = "Chen"
    @Published var lastNameError: String? = "test error"
    @Published var city = "Toronto"
    @Published var state = "Ontario"
    @Published var country: Country = .canada
    @Published var jobTitle = "App maker"
    @Published var company = "Bytera Inc"
    @Published var field: Field = .tech
    @Published var degree = "Computer Science"
    
    var isValidForm: Bool {
        guard !firstName.isEmpty else {
            firstNameError = "First name must be filled"
            return false
        }
        
        firstNameError = nil
        
        guard !lastName.isEmpty else {
            lastNameError = "First name must be filled"
            return false
        }
        
        lastNameError = nil
        
        return true
    }
    
    func logoutAndQuit() {
        UserManager.shared.logout()
    }
}
