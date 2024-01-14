//
//  HostCalenderViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import Foundation
import SwiftUI

@MainActor
final class HostCalenderViewModel: ObservableObject {
    var myUserId: String
    var timezone: TimeZone = Calendar.current.timeZone
    var scrollViewProxy: ScrollViewProxy?
    
    @Published var isLoading = false
    @Published var timesAvailable: [Timeslot] = []
    @Published var selectedDay: Date = Date()
    @Published var selectedStartTime: Date = Date().startOfDay().getPastOrFutureDate(hour: 9)
    @Published var selectedEndTime: Date = Date().startOfDay().getPastOrFutureDate(hour: 17)
    @Published var addTimeslotError: String?
    
    var startTime: Date {
        Date.buildDateFrom(day: selectedDay, time: selectedStartTime)
    }
    
    var endTime: Date {
        Date.buildDateFrom(day: selectedDay, time: selectedEndTime)
    }
    
    init(myUserId: String) {
        self.myUserId = myUserId
    }
    
    func fetchTimesAvailable() {
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.getAvailability(userId: myUserId)
            if let timesAvailable = response?.data?.timesAvailable {
                self.timesAvailable = timesAvailable.filter { timeslot in
                    return timeslot.start > Date()
                }
            }
            isLoading = false
        }
    }
    
    func addNewTimeSlot() {
        // check if the timeslot is already in the past
        if endTime < Date() {
            addTimeslotError = "Timeslot is in the past"
            return
        }
        
        // check if the new time overlaps with any existing timeslots
        let newTimeslot = Timeslot(start: startTime, end: endTime)
        var overlapWith: Timeslot?
        
        for time in timesAvailable {
            if time.overlap(with: newTimeslot) {
                overlapWith = time
                break
            }
        }
        if let overlappingTimeslot = overlapWith {
            addTimeslotError = "New timeslot overlaps with: \(overlappingTimeslot.timeAndDuration)"
            return
        }
        
        addTimeslotError = nil
        
        timesAvailable.append(newTimeslot)
        timesAvailable.sort { $0.start < $1.start }
        
        saveAvailablity(scrollToBottom: true)
    }
    
    func saveAvailablity(scrollToBottom: Bool) {
        isLoading = true
        let params = SetAvailabilityParams(timezone: timezone.identifier, timesAvailable: timesAvailable)
        
        Task {
            let response = try? await ClickAPI.shared.setAvailability(params: params)
            if response?.success ?? false {
                addTimeslotError = nil
                if scrollToBottom {
                    scrollViewProxy?.scrollTo("bottom", anchor: .bottom)
                }
            } else {
                addTimeslotError = "Error saving available timeslots"
            }
            isLoading = false
        }
    }
}

