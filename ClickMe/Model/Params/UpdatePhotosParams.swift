//
//  UpdatePhotosParams.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-28.
//

import Foundation
import Alamofire

struct UpdatePhotosParams {
    var userPhotos: [Photo]
    
    func params() -> Parameters {
        var params: Parameters = [:]
        var userPhotosArray: [Parameters] = []
        for userPhoto in userPhotos {
            userPhotosArray.append(userPhoto.params())
        }
        params["userPhotos"] = userPhotosArray
        return params
    }
}
