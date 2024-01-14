//
//  SetAvailabilityParams.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation
import Alamofire

struct SetAvailabilityParams {
    var timezone: String
    var timesAvailable: [Timeslot]
 
    func params() -> Parameters {
        var params: Parameters = [:]
        params["timezone"] = timezone
        
        var timeslotsArray: [Parameters] = []
        for time in timesAvailable {
            timeslotsArray.append(time.params())
        }
        params["timesAvailable"] = timeslotsArray
        
        return params
    }
}

