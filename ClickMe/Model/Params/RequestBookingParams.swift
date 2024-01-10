//
//  RequestBookingParams.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation
import Alamofire

struct RequestBookingParams {
    var topicId: String
    var startTime: Date
    var endTime: Date
 
    func params() -> Parameters {
        var params: Parameters = [:]
        params["topicId"] = topicId
        params["startTime"] = startTime
        params["endTime"] = endTime
        return params
    }
}
