//
//  HostCalenderView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct HostCalenderView: View {
    @StateObject var viewModel: HostCalenderViewModel
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: HostCalenderViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        ZStack {
            ScrollViewReader { (proxy: ScrollViewProxy) in
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
                                        viewModel.saveAvailablity(scrollToBottom: false)
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
                        .id("bottom")
                    }
                }
                .onAppear {
                    viewModel.scrollViewProxy = proxy
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

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    return HostCalenderView(myProfile: MockData.mockProfile2())
}
