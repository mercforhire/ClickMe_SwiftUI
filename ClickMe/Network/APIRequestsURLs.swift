//
//  APIRequestsURLs.swift
//  ClickMe
//
//  Created by Leon Chen on 2021-06-28.
//

import Foundation
import Alamofire

enum APIRequestURLs: String {
    case getEmailCode = "/api/users/authentication/sendCodeToEmail"
    case checkLoginEmail = "/api/users/authentication/checkLoginEmail"
    case checkRegisterEmail = "/api/users/authentication/checkRegisterEmail"
    case login = "/api/users/authentication/login"
    case registerNewUser = "/api/users/authentication/registerNewUser"
    
    func getHTTPMethod() -> HTTPMethod {
        switch self {
        case .getEmailCode:
            return .post
        case .login:
            return .post
        case .registerNewUser:
            return .post
        case .checkLoginEmail:
            return .post
        case .checkRegisterEmail:
            return .post
        }
    }
    
    static func needAuthToken(url: String) -> Bool {
        if url.contains(APIRequestURLs.getEmailCode.rawValue) ||
            url.contains(APIRequestURLs.checkLoginEmail.rawValue) ||
            url.contains(APIRequestURLs.checkRegisterEmail.rawValue) ||
            url.contains(APIRequestURLs.login.rawValue) ||
            url.contains(APIRequestURLs.registerNewUser.rawValue) {
            return false
        }
        return true
    }
}
