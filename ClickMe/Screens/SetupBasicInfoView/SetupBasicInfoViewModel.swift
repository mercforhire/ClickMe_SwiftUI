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
    @Published var field: Field = .other
    @Published var degree = ""
}
