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
    case loginUsingAPIKey = "/api/users/authentication/loginUsingAPIKey"
    case registerNewUser = "/api/users/authentication/registerNewUser"
    case getS3Keys = "/api/config/getS3Keys"
    case getUserProfile = "/api/users/getUserProfile"
    case updateUserProfile = "/api/users/account_update/update"
    case exploreUsers = "/api/users/exploreUsers"
    case exploreTopics = "/api/topics/exploreTopics"
    case searchUser = "/api/users/searchUser"
    case getUserTopics = "/api/topics/getUserTopics"
    case getFollowStatus = "/api/users/getFollowStatus"
    case followUser = "/api/users/followUser"
    case unfollowUser = "/api/users/unfollowUser"
    case getFollowingUsers = "/api/users/getFollowingUsers"
    case getTopic = "/api/topics/getTopic"
    case getConversations = "/api/chat/getConversations"
    
    func getHTTPMethod() -> HTTPMethod {
        switch self {
        case .getEmailCode:
            return .post
        case .login:
            return .post
        case .loginUsingAPIKey:
            return .post
        case .registerNewUser:
            return .post
        case .checkLoginEmail:
            return .post
        case .checkRegisterEmail:
            return .post
        case .getS3Keys:
            return .get
        case .getUserProfile:
            return .get
        case .updateUserProfile:
            return .post
        case .exploreUsers:
            return .post
        case .exploreTopics:
            return .get
        case .searchUser:
            return .post
        case .getUserTopics:
            return .post
        case .getFollowStatus:
            return .get
        case .followUser:
            return .post
        case .unfollowUser:
            return .post
        case .getFollowingUsers:
            return .get
        case .getTopic:
            return .get
        case .getConversations:
            return .get
        }
    }
    
    static func needAuthToken(url: String) -> Bool {
        if url.contains(APIRequestURLs.getEmailCode.rawValue) ||
            url.contains(APIRequestURLs.checkLoginEmail.rawValue) ||
            url.contains(APIRequestURLs.checkRegisterEmail.rawValue) ||
            url.contains(APIRequestURLs.login.rawValue) ||
            url.contains(APIRequestURLs.loginUsingAPIKey.rawValue) ||
            url.contains(APIRequestURLs.registerNewUser.rawValue) {
            return false
        }
        return true
    }
}
