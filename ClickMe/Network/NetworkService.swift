//
//  NetworkService.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation
import Alamofire

class RequestInterceptor: Alamofire.RequestInterceptor {
    var apiKey: String?
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let apiKey = apiKey, let urlString = urlRequest.url?.absoluteString, APIRequestURLs.needAuthToken(url: urlString) else {
            // If the request does not require authentication, we can directly return it as unmodified.
            return completion(.success(urlRequest))
        }
        var urlRequest = urlRequest

        // Set the apiKey in the header
        urlRequest.setValue(apiKey, forHTTPHeaderField: "apiKey")
        completion(.success(urlRequest))
    }
}

class NetworkService {
    private let sessionManager: Session
    private let interceptor = RequestInterceptor()
    
    var apiKey: String? {
        didSet {
            interceptor.apiKey = apiKey
        }
    }
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        sessionManager = Session(interceptor: interceptor)
    }
    
    func httpRequest<T>(url: String, method: HTTPMethod, parameters: Parameters?) async throws -> T where T : Decodable {
        let request = sessionManager.request(url,
                                             method: method,
                                             parameters: parameters,
                                             encoding: JSONEncoding.default,
                                             interceptor: interceptor)
        do {
            let resultObject = try await request.serializingDecodable(T.self).value
            return resultObject
        } catch {
            throw CMError.invalidData
        }
    }
}
