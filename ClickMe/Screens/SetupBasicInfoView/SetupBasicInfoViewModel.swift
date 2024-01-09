//
//  SetupProfileViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation
import SwiftUI

final class SetupBasicInfoViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var firstNameError: String?
    @Published var lastName = ""
    @Published var lastNameError: String?
    @Published var city = ""
    @Published var state = ""
    @Published var country: Country = .canada
    @Published var jobTitle = ""
    @Published var company = ""
    @Published var field: Field = .tech
    @Published var degree = ""
    
    var isValidForm: Bool {
        guard !firstName.isEmpty else {
            firstNameError = "First name must be filled"
            return false
        }
        
        firstNameError = nil
        
        guard !lastName.isEmpty else {
            lastNameError = "Last name must be filled"
            return false
        }
        
        lastNameError = nil
        
        return true
    }
    
    func handleLogOut() {
        UserManager.shared.logout()
        NotificationCenter.default.post(name: Notifications.SwitchToGetStarted, object: nil, userInfo: nil)
    }
}
