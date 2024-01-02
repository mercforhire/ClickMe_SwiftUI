//
//  LoginViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var emailAddress = ""
    @Published var emailAddressError: String?
    @Published var code = ""
    @Published var codeError: String?
    @Published var secondsUntilAllowedSendAgain = 0
    @Published var loginComplete = false
    
    var getCodeButtonTitle: LocalizedStringKey {
        return secondsUntilAllowedSendAgain == 0 ? "Get Code" : "\(secondsUntilAllowedSendAgain) seconds"
    }
    var timer: Timer?
    
    var loginButtonEnabled: Bool {
        return !emailAddress.isEmpty && emailAddress.isValidEmail && !code.isEmpty
    }
    
    func verifyEmailAddress() {
        guard !emailAddress.isEmpty, emailAddress.isValidEmail else {
            return
        }
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.checkLoginEmail(email: emailAddress)
                print(response)
                emailAddressError = nil
            } catch {
                switch error {
                case CMError.userDoesntExist:
                    emailAddressError = "User doesn't exist"
                default:
                    print(error)
                    emailAddressError = "Unknown error"
                }
            }
            isLoading = false
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
    
    func login() async {
        guard !emailAddress.isEmpty, emailAddress.isValidEmail else {
            return
        }
        
        if code.isEmpty {
            codeError = "Verification code is empty"
            return
        }
        codeError = nil
        
        isLoading = true
        do {
            let response = try await ClickAPI.shared.login(email: emailAddress, code: code)
            print(response)
            loginComplete = true
        } catch {
            switch error {
            case CMError.userDoesntExist:
                emailAddressError = "User doesn't exist"
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
