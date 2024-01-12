//
//  HostCalenderView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct HostCalenderView: View {
    @StateObject var viewModel: HostCalenderViewModel
    
    init(myUserId: String) {
        _viewModel = StateObject(wrappedValue: HostCalenderViewModel(myUserId: myUserId))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section("Your timezone") {
                        Text(viewModel.timezone.identifier)
                            .font(.subheadline)
                    }
                    
                    Section("Available times") {
                        ForEach(Array(viewModel.timesAvailable.enumerated()), id: \.offset) { index, timeslot in
                            Text(timeslot.timeAndDuration)
                                .font(.subheadline)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.timesAvailable.remove(at: index)
                                    } label: {
                                        Label("Delete", systemImage: "xmark.bin")
                                    }
                                }
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
                            .datePickerStyle(.compact)
                            DatePicker(
                                "End time:",
                                selection: $viewModel.selectedEndTime,
                                displayedComponents: [.hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                        }
                        
                        if let addTimeslotError = viewModel.addTimeslotError {
                            CMErrorLabel(addTimeslotError)
                        }
                        
                        Button {
                            viewModel.addNewTimeSlot()
                        } label: {
                            CMButton(title: "Add time slot")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationTitle("Available times")
            .onAppear {
                viewModel.fetchTimesAvailable()
            }
            .onAppear {
                UIDatePicker.appearance().minuteInterval = 30
            }
            .onDisappear {
                UIDatePicker.appearance().minuteInterval = 1
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return HostCalenderView(myUserId: MockData.mockProfile().userId)
}
