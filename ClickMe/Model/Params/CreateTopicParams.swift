//
//  CreateTopicParams.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-13.
//

import Foundation
import Alamofire

struct CreateTopicParams {
    var title: String
    var keywords: [String]
    var description: String
    var maxTimeMinutes: Int
    var priceHour: Int
    var currency: Currency
    var mood: Mood
 
    func params() -> Parameters {
        var params: Parameters = [:]
        params["title"] = title
        params["keywords"] = keywords
        params["description"] = description
        params["maxTimeMinutes"] = maxTimeMinutes
        params["priceHour"] = priceHour
        params["currency"] = currency.rawValue
        params["mood"] = mood.rawValue
        return params
    }
}
