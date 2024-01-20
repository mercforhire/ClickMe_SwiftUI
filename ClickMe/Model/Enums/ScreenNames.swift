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
         myBookings,
         bookingRequested
    case chat(UserProfile)
    case myPastBookings
    case hostPastBookings
    case bookingDetails(Request)
    case editProfile
    case usersList(UsersListTypes)
    case topicDetails(Topic)
    case selectTime(Topic, UserProfile)
    case confirmBooking(Topic, UserProfile, Date, Date)
    case hostRequestOverview(Request)
    case hostBookingFinal(BookingAction)
    case editTopic(Topic?)
    case reviews(UserProfile)
    case following
    case hostCalendar
    case followingTopics
    case wallet
    case receiptDetails(Receipt)
}
