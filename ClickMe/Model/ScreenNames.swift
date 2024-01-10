//
//  ScreenNames.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import Foundation

enum ScreenNames: Hashable {
    case splash,
         getStarted,
         loginInitial,
         login,
         register,
         setupBasicInfo,
         setupDetailInfo,
         inbox,
         chat,
         myBookings
    case myPastBookings(String)
    case bookingDetails(Request)
    case editProfile(UserProfile)
}
