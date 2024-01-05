//
//  UpdateUser.swift
//  ClickMe
//
//  Created by Leon Chen on 2021-06-17.
//

import Foundation
import Alamofire

struct UpdateProfileParams {
    var firstName: String
    var lastName: String
    var city: String
    var state: String
    let country: Country
    var jobTitle: String
    var company: String
    var field: Field
    var degree: String
    var aboutMe: String
    var userPhotos: [Photo]
    var languages: [Language]
    
    func params() -> Parameters {
        var params: Parameters = [:]
        params["firstName"] = firstName
        params["lastName"] = lastName
        params["city"] = city
        params["state"] = state
        params["country"] = country.rawValue
        params["jobTitle"] = jobTitle
        params["company"] = company
        params["field"] = field.rawValue
        params["degree"] = degree
        params["aboutMe"] = aboutMe

        var userPhotosArray: [Parameters] = []
        for userPhoto in userPhotos {
            userPhotosArray.append(userPhoto.params())
        }
        params["userPhotos"] = userPhotosArray
        
        var languagesArray: [String] = []
        for language in languages {
            languagesArray.append(language.rawValue)
        }
        params["languages"] = languagesArray

        return params
    }
}
