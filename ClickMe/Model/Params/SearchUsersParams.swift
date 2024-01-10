//
//  SearchUsersParams.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation
import Alamofire

struct SearchUsersParams {
    var keyword: String
 
    func params() -> Parameters {
        var params: Parameters = [:]
        params["keyword"] = keyword
        return params
    }
}
