//
//  SignUpViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var emailAddress = ""
    @Published var emailAddressError: String?
    @Published var code = ""
    @Published var codeError: String?
    @Published var agreeToTermsOfUse = false
    @Published var secondsUntilAllowedSendAgain = 0
    @Published var isPresentingTermsOfUse = false
    @Published var isPresentingPrivacy = false
    @Published var registerComplete = false
    
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
                emailAddressError = nil
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
        guard emailAddressError == nil else { return }
        
        if emailAddress.isEmpty {
            emailAddressError = "Email address empty"
            return
        }
        
        if !emailAddress.isValidEmail {
            emailAddressError = "Email address invalid"
            return
        }
        emailAddressError = nil
        
        isLoading = true
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
            isLoading = false
        }
        
        startCountdown()
    }
    
    func register() async {
        guard !emailAddress.isEmpty, emailAddress.isValidEmail, agreeToTermsOfUse else {
            return
        }
        
        if code.isEmpty {
            codeError = "Verification code is empty"
            return
        }
        codeError = nil
        
        isLoading = true
        do {
            let loginResponse = try await ClickAPI.shared.registerNewUser(email: emailAddress, code: code)
            if let user = loginResponse.data?.user, let profile = loginResponse.data?.profile {
                UserManager.shared.set(user: user, profile: profile)
                registerComplete = true
            }
        } catch {
            switch error {
            case CMError.emailAlreadyTaken:
                emailAddressError = "Email is already taken by another user"
            case CMError.verifyCodeInvalid:
                codeError = "Verification code is invalid"
            case CMError.userDeletedAccount:
                codeError = "This user already deleted his/her account"
            default:
                print(error)
                codeError = "Unknown error"
            }
        }
        isLoading = false
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
