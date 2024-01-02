//
//  AuthenticationService.swift
//  ClickMe
//
//  Created by Leon Chen on 2021-05-28.
//

import Foundation
import Alamofire

class ClickAPI {
    static let shared = ClickAPI()
    
    var baseURL: String = "https://eastus2.azure.data.mongodb-api.com/app/clickme-backend-jnkdw/endpoint"
    let service: NetworkService
    
    init() {
        self.service = NetworkService()
    }
    
    func sendCodeToEmail(email: String, skipSendingEmail: Bool = false) async throws -> DefaultResponse {
        let parameters = ["email": email, "skipSendingEmail": skipSendingEmail ? "true" : "false"]
        let url = baseURL + APIRequestURLs.getEmailCode.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getEmailCode.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "FUNCTION_CALLED_TOO_FREQUENTLY" {
            throw CMError.sendCodeToEmailCalledTooFrequently
        }
        return response
    }
    
    func checkRegisterEmail(email: String) async throws -> DefaultResponse {
        let parameters = ["email": email]
        let url = baseURL + APIRequestURLs.checkRegisterEmail.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.checkRegisterEmail.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "EMAIL_ALREADY_USED" {
            throw CMError.emailAlreadyTaken
        }
        return response
    }
    
    func checkLoginEmail(email: String) async throws -> DefaultResponse {
        let parameters = ["email": email]
        let url = baseURL + APIRequestURLs.checkLoginEmail.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.checkLoginEmail.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "USER_OF_EMAIL_DOESNT_EXIST" {
            throw CMError.userDoesntExist
        }
        return response
    }
    
    func registerNewUser(email: String, code: String) async throws -> LoginResponse {
        let parameters = ["email": email, "code": code]
        let url = baseURL + APIRequestURLs.registerNewUser.rawValue
        let response: LoginResponse = try await service.httpRequest(url: url, method: APIRequestURLs.registerNewUser.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "EMAIL_ALREADY_USED" {
            throw CMError.emailAlreadyTaken
        } else if !response.success, response.message == "VALIDATION_CODE_INVALID" {
            throw CMError.verifyCodeInvalid
        }
        return response
    }
    
    func login(email: String, code: String) async throws -> LoginResponse {
        let parameters = ["email": email, "code": code]
        let url = baseURL + APIRequestURLs.login.rawValue
        let response: LoginResponse = try await service.httpRequest(url: url, method: APIRequestURLs.login.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "USER_OF_EMAIL_DOESNT_EXIST" {
            throw CMError.userDoesntExist
        } else if !response.success, response.message == "VALIDATION_CODE_INVALID" {
            throw CMError.verifyCodeInvalid
        } else if !response.success, response.message == "USER_ALREADY_DELETED_ACCOUNT" {
            throw CMError.userDeletedAccount
        }
        return response
    }
}
