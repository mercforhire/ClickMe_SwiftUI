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
    
    func getS3Keys() async throws -> S3KeysResponse {
        let url = baseURL + APIRequestURLs.getS3Keys.rawValue
        let response: S3KeysResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getS3Keys.getHTTPMethod(), parameters: nil)
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
    
    func getFollowingUsers(userId: String) async throws -> FollowingUsersResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getFollowingUsers.rawValue
        let response: FollowingUsersResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getFollowingUsers.getHTTPMethod(), parameters: parameters)
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
}
