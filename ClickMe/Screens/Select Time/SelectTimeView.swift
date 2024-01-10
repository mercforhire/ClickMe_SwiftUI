//
//  SelectTimeView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import SwiftUI

struct SelectTimeView: View {
    @StateObject var viewModel: SelectTimeViewModel
    
    init(host: UserProfile, topic: Topic) {
        _viewModel = StateObject(wrappedValue: SelectTimeViewModel(host: host, topic: topic))
    }
    
    var body: some View {
        ZStack {
            Form {
                Section("Host timezone") {
                    Text(viewModel.timezone ?? "Unknown timezone")
                }
                
                Section("Available times") {
                    ForEach(viewModel.timesAvailable) { timeslot in
                        Text(timeslot.timeAndDuration)
                    }
                }
                
                Section("Existing bookings") {
                    ForEach(viewModel.futureBookings) { booking in
                        Text(booking.timeAndDuration)
                    }
                }
                
                Section("Select a day") {
                    DatePicker(
                        "",
                        selection: $viewModel.selectedDay,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                }
                
                Section("Pick a start and end time") {
                    VStack {
                        DatePicker(
                            "Start time:",
                            selection: $viewModel.selectedStartTime,
                            displayedComponents: [.hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        
                        DatePicker(
                            "End time:",
                            selection: $viewModel.selectedEndTime,
                            displayedComponents: [.hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                    }
                }
                
                if let availabilityError = viewModel.availabilityError {
                    CMErrorLabel(availabilityError)
                }
                
                Button {
                    viewModel.checkBookingAvailability()
                } label: {
                    CMButton(title: "Check if available")
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Select a time")
        .onAppear {
            viewModel.fetchHostTimeslots()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return SelectTimeView(host: MockData.mockProfile2(), topic: MockData.mockTopic())
}
