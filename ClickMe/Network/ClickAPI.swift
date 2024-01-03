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
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func uploadS3file(fileUrl: URL, fileName: String, progress: progressBlock?, completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?) {
        guard let bucketName else { return }
        
        let expression  = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task: AWSS3TransferUtilityTask, progress: Progress) -> Void in
            print("Uploading: \(progress.fractionCompleted)")
            if progress.isFinished {
                print("Upload Finished...")
            }
        }
        
        expression.setValue("public-read-write", forRequestHeader: "x-amz-acl")
        expression.setValue("public-read-write", forRequestParameter: "x-amz-acl")
        
        AWSS3TransferUtility.default().uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: "image/jpg", expression: expression, completionHandler: completionHandler).continueWith(block: { task in
            if task.error != nil {
                print("Error uploading file: \(String(describing: task.error?.localizedDescription))")
            }
            if task.result != nil {
                print("Starting upload...")
            }
            return nil
        })
    }
    
    func deleteS3file(fileURL: String, progress: progressBlock?, completion: completionBlock?) {
        guard let bucketName else { return }
        
        let fileName = fileURL.components(separatedBy: s3RootURL).last
        let request = AWSS3DeleteObjectRequest()!
        request.bucket = bucketName
        request.key = fileName
        
        let s3Service = AWSS3.default()
        s3Service.deleteObject(request).continueWith { task in
            if let error = task.error {
                print("Error occurred: \(error)")
                completion?(task.result, error)
                return nil
            }
            print("Bucket deleted successfully.")
            completion?(task.result, nil)
            return nil
        }
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
        }
        return response
    }
    
    func getS3Keys() async throws -> S3KeysResponse {
        let url = baseURL + APIRequestURLs.getS3Keys.rawValue
        let response: S3KeysResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getS3Keys.getHTTPMethod(), parameters: nil)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        }
        return response
    }
    
    func getUserProfile(userId: String) async throws -> S3KeysResponse {
        let parameters = ["userId": userId]
        let url = baseURL + APIRequestURLs.getUserProfile.rawValue
        let response: S3KeysResponse = try await service.httpRequest(url: url, method: APIRequestURLs.getUserProfile.getHTTPMethod(), parameters: parameters)
        if !response.success, response.message == "APIKEY_INVALID" {
            throw CMError.invalidApiKey
        }
        return response
    }
}
