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
}
