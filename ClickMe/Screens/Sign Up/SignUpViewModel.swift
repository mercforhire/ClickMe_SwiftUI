//
//  SignUpViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

final class SignUpViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var emailAddress = "feiyangca@yahoo.ca"
    @Published var emailAddressError: String?
    @Published var code = ""
    @Published var codeError: String?
    @Published var agreeToTermsOfUse = false
    @Published var secondsUntilAllowedSendAgain = 0
    @Published var isPresentingTermsOfUse = false
    @Published var isPresentingPrivacy = false
    var getCodeButtonTitle: LocalizedStringKey {
        return secondsUntilAllowedSendAgain == 0 ? "Get Code" : "\(secondsUntilAllowedSendAgain) seconds"
    }
    var timer: Timer?
    
    func verifyEmailAddress() {
        guard !emailAddress.isEmpty, emailAddress.isValidEmail else {
            return
        }
        
        Task {
            do {
                let response = try await ClickAPI.shared.checkRegisterEmail(email: emailAddress)
                print(response)
            } catch {
                switch error {
                case CMError.emailAlreadyTaken:
                    emailAddressError = "Email is already taken by another user"
                default:
                    print(error)
                    emailAddressError = "Unknown error"
                }
            }
        }
    }
    
    func sendCode() {
        if emailAddress.isEmpty {
            emailAddressError = "Email address empty"
            return
        }
        
        if !emailAddress.isValidEmail {
            emailAddressError = "Email address invalid"
            return
        }
        emailAddressError = nil
        
        Task {
            do {
                let response = try await ClickAPI.shared.sendCodeToEmail(email: emailAddress)
                print(response)
            } catch {
                switch error {
                case CMError.sendCodeToEmailCalledTooFrequently:
                    codeError = "Please wait before sending another code"
                default:
                    print(error)
                    codeError = "Unknown error"
                }
            }
        }
        
        startCountdown()
    }
    
    func verifyCode() {
        
    }
    
    private func startCountdown() {
        secondsUntilAllowedSendAgain = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            guard let self else { return }
            
            if self.secondsUntilAllowedSendAgain == 0 {
                timer.invalidate()
                self.timer = nil
                return
            }
            
            self.secondsUntilAllowedSendAgain = self.secondsUntilAllowedSendAgain - 1
        })
    }
}
