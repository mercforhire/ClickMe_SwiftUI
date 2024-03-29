//
//  File.swift
//  ClickMe
//
//  Created by Leon Chen on 2021-05-01.
//

import UIKit
import Alamofire

struct Photo: Codable, Identifiable, Hashable, Equatable {
    var id: String { return "\(thumbnail)_\(url)" }
    var thumbnail: String
    var url: String
    
    func params() -> Parameters {
        var params: Parameters = [:]
        params["thumbnail"] = thumbnail
        params["url"] = url
        return params
    }
}
