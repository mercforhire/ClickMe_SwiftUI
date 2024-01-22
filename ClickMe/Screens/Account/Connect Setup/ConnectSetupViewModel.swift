//
//  ConnectSetupViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-20.
//

import Foundation

enum ConnectAccountTypes: String, Codable, Identifiable, Hashable, CaseIterable {
    case individual
    case company
    case non_profit
    
    var id: Self { self }
    
    func text() -> String {
        switch self {
        case .individual:
            return "Individual"
        case .company:
            return "Company"
        case .non_profit:
            return "Non Profit"
        }
    }
}

@MainActor
final class ConnectSetupViewModel: ObservableObject {
    var myUser: User
    
    @Published var isLoading = false
    @Published var connectedAccount: StripeAccount?
    @Published var accountLink: AccountLink?
    
    @Published var email = ""
    @Published var emailError: String?
    @Published var type: ConnectAccountTypes = .individual
    @Published var country: Country = .canada
    @Published var countryError: String?
    
    @Published var isPresentingAccountLink = false
    @Published var setupConnectError: String?
    
    var isValidForm: Bool {
        guard !email.isEmpty else {
            emailError = "Email must be filled"
            return false
        }
        emailError = nil
        
        guard email.isValidEmail else {
            emailError = "Email invalid"
            return false
        }
        emailError = nil
        
        if connectedAccount == nil {
            guard country != .other else {
                countryError = "Sorry, this app can only pay out to hosts in Canada or USA for now"
                return false
            }
            countryError = nil
        }
        
        return true
    }
    
    init(myUser: User) {
        self.myUser = myUser
    }
    
    func fetchData() {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.getWalletDetails()
            if let connectedAccount = response?.data?.connectedAccount {
                self.connectedAccount = connectedAccount
                initDataFromExistingCustomer()
            } else {
                initDataFromUser()
            }
            isLoading = false
        }
    }
    
    func initDataFromExistingCustomer() {
        guard let connectedAccount else { return }
        
        email = connectedAccount.email
        country = Country(stripeValue: connectedAccount.country) ?? .other
    }
    
    func initDataFromUser() {
        email = myUser.email
    }
    
    func checkForAccountCompletion() -> Bool {
        guard let connectedAccount else { return false }
        
        return connectedAccount.payouts_enabled
    }
    
    func setupConnectAccount() {
        guard isValidForm else { return }
        
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.setupConnectAccount(email: email, businessType: type, country: country)
            if response?.success ?? false {
                setupConnectError = nil
                fetchData()
            } else {
                setupConnectError = "Something went wrong"
            }
            isLoading = false
        }
    }
    
    func getOnboardLink() {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.getStripeOnboardingLink()
            if let accountLink = response?.data?.accountLink {
                self.accountLink = accountLink
                isPresentingAccountLink = true
            } else {
                setupConnectError = "Something went wrong"
            }
            isLoading = false
        }
    }
    
    func urlChangeHandler(_ url: String) -> Bool {
        guard let stripeReturnUrl = UserManager.shared.stripeReturnUrl else { return false }
        
        if url.contains(stripeReturnUrl) {
            fetchData()
            return true
        }
        
        return false
    }
}
