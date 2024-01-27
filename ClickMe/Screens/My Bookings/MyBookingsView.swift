//
//  MyBookingsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import SwiftUI

struct MyBookingsView: View {
    @StateObject var viewModel: MyBookingsViewModel
    @State private var navigationPath: [ScreenNames] = []
    
    private let screenHeight = UIScreen.main.bounds.size.height
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: MyBookingsViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(viewModel.requests, id: \.self) { request in
                    BookingRequestView(request: request)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            navigationPath.append(.bookingDetails(request))
                        }
                }
                if viewModel.requests.isEmpty {
                    CMEmptyView(imageName: "empty", message: "No booking requests")
                        .padding(.top, screenHeight * 0.1)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.fetchRequests()
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        navigationPath.append(.myPastBookings)
                    } label: {
                        Image("previous-date", bundle: nil)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Archive")
                    }
                }
            }
            .navigationTitle("My bookings")
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.bookingDetails(let request):
                    BookingStatusView(myProfile: viewModel.myProfile, 
                                      request: request, 
                                      navigationPath: $navigationPath)
                    
                case ScreenNames.myPastBookings:
                    MyPastBookingsView(myProfile: viewModel.myProfile, 
                                       navigationPath: $navigationPath)
                    
                case ScreenNames.reportIssues(let host, let topic, let request, let receipt):
                    ReportIssueView(myUserId: viewModel.myProfile.userId,
                                    host: host,
                                    topic: topic,
                                    request: request,
                                    receipt: receipt)
                default:
                    fatalError()
                }
            }
            .onAppear() {
                viewModel.fetchRequests()
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return MyBookingsView(myProfile: MockData.mockProfile())
}
