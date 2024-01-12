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
         myBookings,
         bookingRequested
    case myPastBookings(String)
    case hostPastBookings(String)
    case bookingDetails(Request)
    case editProfile(UserProfile)
    case usersList(UsersListTypes, String)
    case topicDetails(Topic)
    case selectTime(Topic, UserProfile)
    case confirmBooking(Topic, UserProfile, Date, Date)
    case hostBookingFinal(BookingAction)
}
