//
//  AuthenticationService.swift
//  ClickMe
//
//  Created by Leon Chen on 2021-05-28.
//

import Foundation
import Alamofire
import AWSS3
import AWSCore

typealias progressBlock = (_ progress: Double) -> Void
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void

class ClickAPI {
    static let shared = ClickAPI()
    
    private let baseURL: String = "https://eastus2.azure.data.mongodb-api.com/app/clickme-backend-jnkdw/endpoint"
    private let s3RootURL: String = "https://clickemeimage.s3.ca-central-1.amazonaws.com/"
    private var bucketName: String?
    private let service: NetworkService
    
    var apiKey: String? {
        set {
            service.apiKey = newValue
        }
        get {
            return service.apiKey
        }
    }
    
    init() {
        self.service = NetworkService()
    }
    
    func initializeS3(bucketName: String, s3Key: String, accessKey: String) {
        self.bucketName = bucketName
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: s3Key, secretKey: accessKey)
        let configuration = AWSServiceConfiguration(region: .CACentral1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func uploadS3file(fileUrl: URL, fileName: String) async throws -> Void {
        guard let bucketName else { return }
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            AWSS3TransferUtility.default().uploadFile(fileUrl,
                                                      bucket: bucketName,
                                                      key: fileName,
                                                      contentType: "image/jpg",
                                                      expression: nil,
                                                      completionHandler: { task, error in
                if let error = task.error {
                    print("CMError.s3UploadFailed: ", error)
                    continuation.resume(throwing: CMError.s3UploadFailed)
                } else {
                    continuation.resume()
                }
            })
        }
    }
    
    func deleteS3file(fileURL: String) async throws -> Void {
        guard let bucketName else { return }
        
        let fileName = fileURL.components(separatedBy: s3RootURL).last
        let request = AWSS3DeleteObjectRequest()!
        request.bucket = bucketName
        request.key = fileName
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            AWSS3.default().deleteObject(request).continueWith { task in
                if let error = task.error {
                    print("Error occurred: \(error)")
                    continuation.resume(throwing: CMError.s3DeleteFailed)
                } else {
                    print("Bucket deleted successfully.")
                    continuation.resume()
                }
                return
            }
        }
    }
    
    func uploadPhoto(userId: String, photo: UIImage) async throws -> Photo? {
        let filename = String.randomString(length: 5)
        let thumbnailFileName = "\(userId)-\(filename)-thumb.jpg"
        let fullsizeFileName = "\(userId)-\(filename)-full.jpg"
        let thumbnailImage = photo.resize(640, 480)
        let fullSizeImage = photo.resize(1920, 1080)
        
        guard let thumbnailImageData = thumbnailImage.jpeg,
              let fullSizeImageData = fullSizeImage.jpeg,
              let thumbnailDataUrl = Utils.saveImageToDocumentDirectory(filename: thumbnailFileName, jpegData: thumbnailImageData),
              let fullSizeDataUrl = Utils.saveImageToDocumentDirectory(filename: fullsizeFileName, jpegData: fullSizeImageData)
        else { return nil }
        
        do {
            try await uploadS3file(fileUrl: thumbnailDataUrl, fileName: thumbnailFileName)
            try await uploadS3file(fileUrl: fullSizeDataUrl, fileName: fullsizeFileName)
        } catch {
            throw error
        }
        
        let finalThumbnailURL = "\(s3RootURL)\(thumbnailFileName)"
        let finalFullURL = "\(s3RootURL)\(fullsizeFileName)"
        return Photo(thumbnail: finalThumbnailURL, url: finalFullURL)
    }
    
    func sendCodeToEmail(email: String, skipSendingEmail: Bool = false) async throws -> DefaultResponse {
        let parameters = ["email": email, "skipSendingEmail": skipSendingEmail ? "true" : "false"]
        let url = baseURL + APIRequestURLs.getEmailCode.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getEmailCode.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "FUNCTION_CALLED_TOO_FREQUENTLY" {
            throw CMError.sendCodeToEmailCalledTooFrequently
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func checkRegisterEmail(email: String) async throws -> DefaultResponse {
        let parameters = ["email": email]
        let url = baseURL + APIRequestURLs.checkRegisterEmail.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.checkRegisterEmail.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "EMAIL_ALREADY_USED" {
            throw CMError.emailAlreadyTaken
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func checkLoginEmail(email: String) async throws -> DefaultResponse {
        let parameters = ["email": email]
        let url = baseURL + APIRequestURLs.checkLoginEmail.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.checkLoginEmail.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "USER_OF_EMAIL_DOESNT_EXIST" {
            throw CMError.userDoesntExist
        } else if !response.success {
            throw CMError.unableToComplete
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
        } else if !response.success {
            throw CMError.unableToComplete
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
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func loginUsingAPIKey(apiKey: String) async throws -> LoginResponse {
        let parameters = ["apiKey": apiKey]
        let url = baseURL + APIRequestURLs.loginUsingAPIKey.rawValue
        let response: LoginResponse = try await service.httpRequest(url: url, method: APIRequestURLs.loginUsingAPIKey.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "USER_ALREADY_DELETED_ACCOUNT" {
            throw CMError.userDeletedAccount
        } else if !response.success, response.message == "USER_NOT_FOUND" {
            throw CMError.userDoesntExist
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getAppKeys() async throws -> AppKeysResponse {
        let url = baseURL + APIRequestURLs.getAppKeys.rawValue
        let response: AppKeysResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getAppKeys.getHTTPMethod(), parameters: nil)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getUserProfile(userId: String) async throws -> UpdateUserProfileResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getUserProfile.rawValue
        let response: UpdateUserProfileResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getUserProfile.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func updateUserProfile(params: UpdateProfileParams) async throws -> UpdateUserProfileResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.updateUserProfile.rawValue
        let response: UpdateUserProfileResponse = try await service.httpRequest(url: url, method: APIRequestURLs.updateUserProfile.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func explore(params: ExploreUsersParams) async throws -> ExploreUsersResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.exploreUsers.rawValue
        let response: ExploreUsersResponse = try await service.httpRequest(url: url, method: APIRequestURLs.exploreUsers.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func exploreTopics(mood: Mood?) async throws -> TopicsResponse {
        var parameters: Parameters = [:]
        if let mood {
            parameters["mood"] = mood.rawValue
        }
        let url = baseURL + APIRequestURLs.exploreTopics.rawValue
        let response: TopicsResponse = try await service.httpRequest(url: url, method: APIRequestURLs.exploreTopics.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func searchUsers(params: SearchUsersParams) async throws -> SearchUsersResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.searchUser.rawValue
        let response: SearchUsersResponse = try await service.httpRequest(url: url, method: APIRequestURLs.searchUser.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getUserTopics(userId: String) async throws -> TopicsResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getUserTopics.rawValue
        let response: TopicsResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getUserTopics.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "USER_DOES_NOT_EXIST" {
            throw CMError.userDoesntExist
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getFollowStatus(followerUserId: String, followingUserId: String) async throws -> DefaultResponse {
        let parameters = ["followerUserId": followerUserId, "followingUserId": followingUserId]
        let url = baseURL + APIRequestURLs.getFollowStatus.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getFollowStatus.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func follow(followingUserId: String) async throws -> DefaultResponse {
        let parameters = ["followingUserId": followingUserId]
        let url = baseURL + APIRequestURLs.followUser.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.followUser.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func unfollow(followingUserId: String) async throws -> DefaultResponse {
        let parameters = ["followingUserId": followingUserId]
        let url = baseURL + APIRequestURLs.unfollowUser.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.unfollowUser.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getFollowingUsers(userId: String) async throws -> GetUsersResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getFollowingUsers.rawValue
        let response: GetUsersResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getFollowingUsers.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getFollowers(userId: String) async throws -> GetUsersResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getFollowers.rawValue
        let response: GetUsersResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getFollowers.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getBlockedUsers(userId: String) async throws -> GetUsersResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getBlockedUsers.rawValue
        let response: GetUsersResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getBlockedUsers.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getTopic(topicId: String) async throws -> TopicResponse {
        let parameters = ["topicId": topicId]
        let url = baseURL + APIRequestURLs.getTopic.rawValue
        let response: TopicResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getTopic.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "TOPIC_NOT_FOUND" {
            throw CMError.topicDoesntExist
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getConversations() async throws -> GetConversationsResponse {
        let url = baseURL + APIRequestURLs.getConversations.rawValue
        let response: GetConversationsResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getConversations.getHTTPMethod(), parameters: nil)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getChatMessages(with userId: String) async throws -> GetChatMessagesResponse {
        let parameters = ["withUserId": userId]
        let url = baseURL + APIRequestURLs.getChatMessages.rawValue
        let response: GetChatMessagesResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getChatMessages.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func sendChatMessage(toUserId: String, message: String) async throws -> SendChatMessageResponse {
        let parameters = ["toUserId": toUserId, "message": message]
        let url = baseURL + APIRequestURLs.sendChatMessage.rawValue
        let response: SendChatMessageResponse = try await service.httpRequest(url: url, method: APIRequestURLs.sendChatMessage.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "RECEIVER_BLOCKED_SENDER" {
            throw CMError.chatBlocked
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getBlockStatus(userId: String, blockUserId: String) async throws -> DefaultResponse {
        let parameters = ["userId": userId, "blockUserId": blockUserId]
        let url = baseURL + APIRequestURLs.getBlockStatus.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getBlockStatus.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func block(blockUserId: String, reason: String) async throws -> DefaultResponse {
        let parameters = ["blockUserId": blockUserId, "reason": reason]
        let url = baseURL + APIRequestURLs.blockUser.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.blockUser.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func unblock(blockUserId: String) async throws -> DefaultResponse {
        let parameters = ["blockUserId": blockUserId]
        let url = baseURL + APIRequestURLs.unblockUser.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.unblockUser.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getGuestBookingRequests(userId: String) async throws -> GetBookingRequestsResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getGuestBookingRequests.rawValue
        let response: GetBookingRequestsResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getGuestBookingRequests.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getGuestPastBookingRequests(userId: String) async throws -> GetBookingRequestsResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getGuestPastBookingRequests.rawValue
        let response: GetBookingRequestsResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getGuestPastBookingRequests.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getHostBookingRequests(userId: String) async throws -> GetBookingRequestsResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getHostBookingRequests.rawValue
        let response: GetBookingRequestsResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getHostBookingRequests.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getHostPastBookingRequests(userId: String) async throws -> GetBookingRequestsResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getHostPastBookingRequests.rawValue
        let response: GetBookingRequestsResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getHostPastBookingRequests.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getBookingDetails(requestId: String) async throws -> GetBookingDetailsResponse {
        let parameters = ["requestId": requestId]
        let url = baseURL + APIRequestURLs.getBookingDetails.rawValue
        let response: GetBookingDetailsResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getBookingDetails.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "REQUEST_DOES_NOT_EXIST" {
            throw CMError.requestDoesntExist
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func postFeedback(message: String) async throws -> DefaultResponse {
        let parameters = ["message": message]
        let url = baseURL + APIRequestURLs.postFeedback.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.postFeedback.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func deleteAccount() async throws -> DefaultResponse {
        let url = baseURL + APIRequestURLs.deleteAccount.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url, method: APIRequestURLs.deleteAccount.getHTTPMethod(), parameters: nil)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getAvailability(userId: String) async throws -> GetAvailabilityResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getAvailability.rawValue
        let response: GetAvailabilityResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getAvailability.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "AVAILABILITY_NOT_FOUND_FOR_USER" {
            throw CMError.userDoesntExist
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func requestBooking(params: RequestBookingParams) async throws -> RequestResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.requestBooking.rawValue
        let response: RequestResponse = try await service.httpRequest(url: url, method: APIRequestURLs.requestBooking.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "CAN_NOT_BOOK_OWN_SCHEDULE" {
            throw CMError.cantBookOwn
        } else if !response.success, response.message == "START_TIME_END_TIME_INVALID" {
            throw CMError.invalidBookingTime
        } else if !response.success, response.message == "BOOKING_TIME_EXCEEDS_TOPIC_MAX_LIMIT" {
            throw CMError.bookingTimeTooLong
        } else if !response.success, response.message == "TIME_SLOT_IN_NOT_IN_AVAILABILITY" {
            throw CMError.invalidTimeSlot
        } else if !response.success, response.message == "TIME_SLOT_IN_CONFLICT_WITH_EXISTING_BOOKING" {
            throw CMError.timeslotConflict
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func checkBookingAvailability(params: RequestBookingParams) async throws -> DefaultResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.checkBookingAvailability.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url,
                                                                      method: APIRequestURLs.checkBookingAvailability.getHTTPMethod(),
                                                                      parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "CAN_NOT_BOOK_OWN_SCHEDULE" {
            throw CMError.cantBookOwn
        } else if !response.success, response.message == "START_TIME_END_TIME_INVALID" {
            throw CMError.invalidBookingTime
        } else if !response.success, response.message == "BOOKING_TIME_EXCEEDS_TOPIC_MAX_LIMIT" {
            throw CMError.bookingTimeTooLong
        } else if !response.success, response.message == "TIME_SLOT_IN_NOT_IN_AVAILABILITY" {
            throw CMError.invalidTimeSlot
        } else if !response.success, response.message == "TIME_SLOT_IN_CONFLICT_WITH_EXISTING_BOOKING" {
            throw CMError.timeslotConflict
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getBookingPrice(params: RequestBookingParams) async throws -> GetBookingPriceResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.getBookingPrice.rawValue
        let response: GetBookingPriceResponse = try await service.httpRequest(url: url,
                                                                              method: APIRequestURLs.getBookingPrice.getHTTPMethod(),
                                                                              parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "TOPIC_DOES_NOT_EXIST" {
            throw CMError.topicDoesntExist
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func setAvailability(params: SetAvailabilityParams) async throws -> DefaultResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.setAvailability.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url,
                                                                      method: APIRequestURLs.setAvailability.getHTTPMethod(),
                                                                      parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "BAD_TIME_SLOT" {
            throw CMError.invalidData
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func requestAction(requestId: String, action: BookingAction, message: String) async throws -> DefaultResponse {
        let parameters = ["requestId": requestId, "action": action.apiParameter(), "message": message]
        let url = baseURL + APIRequestURLs.requestAction.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url,
                                                                      method: APIRequestURLs.requestAction.getHTTPMethod(),
                                                                      parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "BOOKING_STATUS_NOT_PENDING" {
            throw CMError.bookingRequestMustBePending
        } else if !response.success, response.message == "BOOKING_CAN_ONLY_BE_CANCELLED_AFTER_IT_IS_APPROVED" {
            throw CMError.bookingRequestMustBeApproved
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func startCallingSession(requestId: String, forceNewToken: Bool = false) async throws -> StartCallSessionResponse {
        let parameters = ["requestId": requestId, "forceNewToken": forceNewToken ? "true" : "false"]
        let url = baseURL + APIRequestURLs.startCallingSession.rawValue
        let response: StartCallSessionResponse = try await service.httpRequest(url: url,
                                                                               method: APIRequestURLs.requestAction.getHTTPMethod(),
                                                                               parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "USER_NOT_SCHEDULE_HOST_NOR_BOOKING_USER" {
            throw CMError.userIsNotInTheBooking
        } else if !response.success, response.message == "BOOKING_REQUEST_STATUS_INVALID" {
            throw CMError.bookingRequestMustBeApproved
        } else if !response.success, response.message == "TOO_EARLY_TO_START_BOOKING_SESSION" {
            throw CMError.tooEarlyToStartSession
        } else if !response.success, response.message == "SESSION_ALREADY_OVER" {
            throw CMError.alreadyPastSessionEndTime
        } else if !response.success, response.message == "AGORA_TOKEN_GENERATION_FAILED" {
            throw CMError.agoraTokenError
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func submitReview(revieweeId: String, requestId: String, rating: Double, comment: String) async throws -> DefaultResponse {
        let parameters: Parameters = ["revieweeId": revieweeId, "requestId": requestId, "rating": rating, "comment": comment]
        let url = baseURL + APIRequestURLs.postReview.rawValue
        let response: DefaultResponse = try await service.httpRequest(url: url,
                                                                      method: APIRequestURLs.postReview.getHTTPMethod(),
                                                                      parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "CAN_ONLY_REVIEW_A_FINISHED_BOOKING" {
            throw CMError.bookingRequestMustBeFinished
        } else if !response.success, response.message == "REVIEWER_IS_NOT_PART_OF_THE_BOOKING" {
            throw CMError.userIsNotInTheBooking
        } else if !response.success, response.message == "REVIEWEE_IS_NOT_PART_OF_THE_BOOKING" {
            throw CMError.userIsNotInTheBooking
        } else if !response.success, response.message == "CAN_NOT_REVIEW_SELF" {
            throw CMError.canNotReviewSelf
        } else if !response.success, response.message == "INVALID_RATING" {
            throw CMError.invalidData
        } else if !response.success, response.message == "COMMENT_IS_EMPTY" {
            throw CMError.reviewMustContainComment
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getReviewsByUser(userId: String) async throws -> GetReviewsResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getReviewsAboutUser.rawValue
        let response: GetReviewsResponse = try await service.httpRequest(url: url,
                                                                         method: APIRequestURLs.getReviewsAboutUser.getHTTPMethod(),
                                                                         parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getUserRatings(userId: String) async throws -> GetUserRatingsResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getUserRatings.rawValue
        let response: GetUserRatingsResponse = try await service.httpRequest(url: url,
                                                                             method: APIRequestURLs.getReviewsAboutUser.getHTTPMethod(),
                                                                             parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func createTopic(params: CreateTopicParams) async throws -> TopicResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.createTopic.rawValue
        let response: TopicResponse = try await service.httpRequest(url: url,
                                                                    method: APIRequestURLs.createTopic.getHTTPMethod(),
                                                                    parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func editTopic(params: EditTopicParams) async throws -> TopicResponse {
        let parameters = params.params()
        let url = baseURL + APIRequestURLs.editTopic.rawValue
        let response: TopicResponse = try await service.httpRequest(url: url,
                                                                    method: APIRequestURLs.editTopic.getHTTPMethod(),
                                                                    parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "TOPIC_DOES_NOT_EXIST" {
            throw CMError.topicDoesntExist
        } else if !response.success, response.message == "USER_DOES_NOT_OWN_THE_TOPIC" {
            throw CMError.userIsNotTopicOwner
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func deleteTopic(topicId: String) async throws -> TopicResponse {
        let parameters = ["topicId": topicId]
        let url = baseURL + APIRequestURLs.deleteTopic.rawValue
        let response: TopicResponse = try await service.httpRequest(url: url,
                                                                    method: APIRequestURLs.deleteTopic.getHTTPMethod(),
                                                                    parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "TOPIC_DOES_NOT_EXIST" {
            throw CMError.topicDoesntExist
        } else if !response.success, response.message == "USER_DOES_NOT_OWN_THE_TOPIC" {
            throw CMError.userIsNotTopicOwner
        } else if !response.success, response.message == "ONGOING_REQUESTS_EXIST_FOR_TOPIC" {
            throw CMError.topicHasOngoingBookings
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getHostStatistics() async throws -> GetHostStatisticsResponse {
        let url = baseURL + APIRequestURLs.getHostStatistics.rawValue
        let response: GetHostStatisticsResponse =
            try await service.httpRequest(url: url,
                                          method: APIRequestURLs.getHostStatistics.getHTTPMethod(),
                                          parameters: nil)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
    
    func getStripePaymentDetails(requestId: String) async throws -> GetStripePaymentDetailsResponse {
        let url = baseURL + APIRequestURLs.getStripePaymentDetails.rawValue
        let response: GetStripePaymentDetailsResponse =
        try await service.httpRequest(url: url,
                                      method: APIRequestURLs.getStripePaymentDetails.getHTTPMethod(),
                                      parameters: nil)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        } else if !response.success, response.message == "RECEIPT_NOT_FOUND" {
            throw CMError.receiptDoesntExist
        } else if !response.success {
            throw CMError.unableToComplete
        }
        return response
    }
}
