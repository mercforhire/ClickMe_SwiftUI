//
//  StripeCustomerSetupViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-20.
//

import Foundation

@MainActor
final class StripeCustomerSetupViewModel: ObservableObject {
    var myUser: User
    
    @Published var isLoading = false
    @Published var customer: StripeCustomer?
    
    @Published var fullName = ""
    @Published var fullNameError: String?
    
    @Published var email = ""
    @Published var emailError: String?
    
    @Published var phone = ""
    
    @Published var setupCustomerComplete = false
    @Published var setupCustomerError: String?
    
    var isValidForm: Bool {
        guard !fullName.isEmpty else {
            fullNameError = "Full name must be filled"
            return false
        }
        fullNameError = nil
        
        guard !email.isEmpty else {
            emailError = "Email must be filled"
            return false
        }
        emailError = nil
        
        guard !email.isValidEmail else {
            emailError = "Email must be filled"
            return false
        }
        emailError = nil
        
        return true
    }
    
    init(myUser: User) {
        self.myUser = myUser
    }
    
    func fetchData() {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.getWalletDetails()
            if let customer = response?.data?.customer {
                self.customer = customer
            }
            isLoading = false
        }
    }
    
    func submitData() {
        guard isValidForm else { return }
        
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.setupStripeCustomer(email: email, name: fullName, phone: phone)
            if response?.success ?? false {
                setupCustomerError = nil
                setupCustomerComplete = true
            } else {
                setupCustomerError = "Something went wrong"
            }
            isLoading = false
        }
    }
}
