//
//  ExploreUsersParams.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import Foundation
import Alamofire

struct ExploreUsersParams {
    var fields: [Field]?
    var languages: [Language]?
    
    func params() -> Parameters {
        var params: Parameters = [:]
        
        if let languages = languages, !languages.isEmpty {
            var languagesArray: [String] = []
            for language in languages {
                languagesArray.append(language.rawValue)
            }
            params["languages"] = languagesArray
        }
        
        if let fields = fields, !fields.isEmpty {
            var fieldsArray: [String] = []
            for field in fields {
                fieldsArray.append(field.rawValue)
            }
            params["fields"] = fieldsArray
        }
        
        return params
    }
}
