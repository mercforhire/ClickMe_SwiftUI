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
        guard let apiKey = apiKey, 
                let urlString = urlRequest.url?.absoluteString,
                APIRequestURLs.needAuthToken(url: urlString) else {
            // If the request does not require authentication, we can directly return it as unmodified.
            return completion(.success(urlRequest))
        }
        var urlRequest = urlRequest

        // Set the apiKey in the header
        urlRequest.setValue(apiKey, forHTTPHeaderField: "apiKey")
        completion(.success(urlRequest))
    }
}

enum DateError: String, Error {
    case invalidDate
}

class NetworkService {
    private let sessionManager: Session
    private let interceptor = RequestInterceptor()
    private let jsonDecoder = JSONDecoder()
    private let formatter = DateFormatter()
    
    var apiKey: String? {
        didSet {
            interceptor.apiKey = apiKey
        }
    }
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        sessionManager = Session(interceptor: interceptor)
        
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        jsonDecoder.dateDecodingStrategy = .custom({ decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = self.formatter.date(from: dateStr) {
                return date
            }
            self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = self.formatter.date(from: dateStr) {
                return date
            }
            throw DateError.invalidDate
        })
    }
    
    func httpRequest<T>(url: String, method: HTTPMethod, parameters: Parameters?) async throws -> T where T : Decodable {
        let request = sessionManager.request(url,
                                             method: method,
                                             parameters: parameters,
                                             encoding: (method == .get || method == .delete) ? URLEncoding.default : JSONEncoding.default,
                                             interceptor: interceptor)
        print(parameters)
        let result = request.serializingDecodable(T.self, decoder: jsonDecoder)
        do {
            let resultObject = try await result.value
            print(resultObject)
            return resultObject
        } catch {
            print(error)
            throw CMError.invalidData
        }
    }
}
