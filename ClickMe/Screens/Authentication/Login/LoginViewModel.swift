//
//  LoginViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var emailAddress = ""
    @Published var emailAddressError: String?
    @Published var code = ""
    @Published var codeError: String?
    @Published var secondsUntilAllowedSendAgain = 0
    
    var timer: Timer?
    
    var getCodeButtonTitle: LocalizedStringKey {
        return secondsUntilAllowedSendAgain == 0 ? "Get Code" : "\(secondsUntilAllowedSendAgain) seconds"
    }
    
    var loginButtonEnabled: Bool {
        return !emailAddress.isEmpty && emailAddress.isValidEmail && !code.isEmpty
    }
    
    func verifyEmailAddress() {
        guard !emailAddress.isEmpty, emailAddress.isValidEmail else {
            return
        }
        Task {
            do {
                let response = try await ClickAPI.shared.checkLoginEmail(email: emailAddress)
                if response.success {
                    emailAddressError = nil
                } else {
                    emailAddressError = "Unknown error"
                }
            } catch {
                switch error {
                case CMError.userDoesntExist:
                    emailAddressError = "User doesn't exist"
                default:
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
        
        Task {
            isLoading = true
            do {
                let response = try await ClickAPI.shared.sendCodeToEmail(email: emailAddress)
                if response.success {
                    codeError = nil
                } else {
                    codeError = "Error with email sending service, please contact support"
                }
            } catch {
                switch error {
                case CMError.sendCodeToEmailCalledTooFrequently:
                    codeError = "Please wait before sending another code"
                default:
                    codeError = "Unknown error"
                }
            }
            isLoading = false
        }
        
        startCountdown()
    }
    
    func login() {
        guard !emailAddress.isEmpty, emailAddress.isValidEmail else {
            return
        }
        
        if code.isEmpty {
            codeError = "Verification code is empty"
            return
        }
        codeError = nil
        
        isLoading = true
        Task {
            do {
                let loginResponse = try await ClickAPI.shared.login(email: emailAddress, code: code)
                if let user = loginResponse.data?.user, let profile = loginResponse.data?.profile {
                    UserManager.shared.set(user: user, profile: profile)
                    await UserManager.shared.fetchAppKeys()
                    
                    NotificationCenter.default.post(name: Notifications.RefreshLoginStatus, object: nil, userInfo: nil)
                    print("go back to initial screen and go to home screen")
                }
            } catch {
                switch error {
                case CMError.userDoesntExist:
                    emailAddressError = "User doesn't exist"
                case CMError.verifyCodeInvalid:
                    codeError = "Verification code is invalid"
                case CMError.userDeletedAccount:
                    codeError = "This user already deleted his/her account"
                default:
                    codeError = "Unknown error"
                }
            }
            isLoading = false
        }
    }
    
    func startCountdown() {
        secondsUntilAllowedSendAgain = 60
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerFunction),
                                     userInfo: nil,
                                     repeats: true)
        timer?.fire()
    }
    
    @objc func timerFunction() {
        if secondsUntilAllowedSendAgain == 0 {
            timer?.invalidate()
            timer = nil
            return
        }
        
        secondsUntilAllowedSendAgain = secondsUntilAllowedSendAgain - 1
    }
}
