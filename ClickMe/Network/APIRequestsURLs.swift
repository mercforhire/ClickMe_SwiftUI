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
    case getFollowers = "/api/users/getFollowers"
    case getTopic = "/api/topics/getTopic"
    case getConversations = "/api/chat/getConversations"
    case getChatMessages = "/api/chat/getChatMessages"
    case sendChatMessage = "/api/chat/sendChatMessage"
    case getBlockStatus = "/api/users/getBlockStatus"
    case blockUser = "/api/users/blockUser"
    case unblockUser = "/api/users/unblockUser"
    case getHostBookingRequests = "/api/topics/getHostBookingRequests"
    case getHostPastBookingRequests = "/api/topics/getHostPastBookingRequests"
    case getGuestBookingRequests = "/api/topics/getGuestBookingRequests"
    case getGuestPastBookingRequests = "/api/topics/getGuestPastBookingRequests"
    case getBookingDetails = "/api/topics/getBookingDetails"
    case postFeedback = "/api/feedback/postFeedback"
    case deleteAccount = "/api/users/deleteAccount"
    case getBlockedUsers = "/api/users/getBlockedUsers"
    case getAvailability = "/api/topics/getAvailability"
    case requestBooking = "/api/topics/requestBooking"
    case checkBookingAvailability = "/api/topics/checkBookingAvailability"
    case getBookingPrice = "/api/topics/getBookingPrice"
    case setAvailability = "/api/topics/setAvailability"
    case requestAction = "/api/topics/requestAction"
    case startCallingSession = "/api/calling/startCallingSession"
    case getReviewsByUser = "/api/topics/getReviewsByUser"
    case postReview = "/api/topics/postReview"
    case getUserRatings = "/api/topics/getUserRatings"
    case createTopic = "/api/topics/createTopic"
    case editTopic = "/api/topics/editTopic"
    case deleteTopic = "/api/topics/deleteTopic"
    case getHostStatistics = "/api/users/getHostStatistics"
    
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
        case .getChatMessages:
            return .get
        case .sendChatMessage:
            return .post
        case .getBlockStatus:
            return .get
        case .blockUser:
            return .post
        case .unblockUser:
            return .post
        case .getHostBookingRequests:
            return .get
        case .getHostPastBookingRequests:
            return .get
        case .getGuestBookingRequests:
            return .get
        case .getGuestPastBookingRequests:
            return .get
        case .getBookingDetails:
            return .get
        case .postFeedback:
            return .post
        case .deleteAccount:
            return .delete
        case .getFollowers:
            return .get
        case .getBlockedUsers:
            return .get
        case .getAvailability:
            return .get
        case .requestBooking:
            return .post
        case .checkBookingAvailability:
            return .post
        case .getBookingPrice:
            return .post
        case .setAvailability:
            return .post
        case .requestAction:
            return .post
        case .startCallingSession:
            return .post
        case .getReviewsByUser:
            return .get
        case .postReview:
            return .post
        case .getUserRatings:
            return .get
        case .createTopic:
            return .post
        case .editTopic:
            return .post
        case .deleteTopic:
            return .delete
        case .getHostStatistics:
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
