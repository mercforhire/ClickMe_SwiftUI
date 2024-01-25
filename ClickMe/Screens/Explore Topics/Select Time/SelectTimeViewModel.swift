//
//  SelectTimeViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation

@MainActor
final class SelectTimeViewModel: ObservableObject {
    var topic: Topic
    var host: UserProfile
    
    @Published var timezone: String?
    @Published var timesAvailable: [Timeslot] = []
    @Published var futureBookings: [Request] = []
    @Published var selectedDay: Date = Date()
    @Published var selectedStartTime: Date = Date()
    @Published var selectedEndTime: Date = Date().getPastOrFutureDate(hour: 1)
    @Published var isLoading = false
    @Published var availabilityError: String?
    @Published var allowedToNext = false
    
    var startTime: Date {
        Date.buildDateFrom(day: selectedDay, time: selectedStartTime)
    }
    
    var endTime: Date {
        Date.buildDateFrom(day: selectedDay, time: selectedEndTime)
    }
    
    init(topic: Topic, host: UserProfile) {
        self.host = host
        self.topic = topic
    }
    
    func fetchHostTimeslots() {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.getAvailability(userId: host.userId)
            if let data = response?.data {
                self.timezone = data.timezone
                self.timesAvailable = data.timesAvailable
                self.futureBookings = data.futureBookings
            }
            isLoading = false
        }
    }
    
    func checkBookingAvailability() {
        if endTime < startTime {
            availabilityError = "Invalid start and finish time"
            return
        }
        
        if endTime < startTime.getPastOrFutureDate(minute: 30) {
            availabilityError = "Timeslot must be at least 30 minutes long."
            return
        }
        
        let params = RequestBookingParams(topicId: topic.id, startTime: startTime, endTime: endTime)
            
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.checkBookingAvailability(params: params)
                if response.success {
                    availabilityError = nil
                    allowedToNext = true
                } else {
                    availabilityError = "Unknown error"
                }
            } catch {
                switch error {
                case CMError.cantBookOwn:
                    availabilityError = "Can't book own topic"
                case CMError.invalidBookingTime:
                    availabilityError = "Invalid start and finish time"
                case CMError.bookingTimeTooLong:
                    availabilityError = "Booking time exceeded topic's max allowed time"
                case CMError.invalidTimeSlot:
                    availabilityError = "Time is not within host's time slots"
                case CMError.timeslotConflict:
                    availabilityError = "Time is in conflict with an existing booking"
                default:
                    availabilityError = "Unknown error"
                }
            }
            isLoading = false
        }
    }
}
