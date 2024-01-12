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
    
    init(myUserId: String) {
        _viewModel = StateObject(wrappedValue: MyBookingsViewModel(myUserId: myUserId))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List(viewModel.requests, id: \.id) { request in
                    BookingRequestView(request: request)
                        .frame(height: 300)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            navigationPath.append(.bookingDetails(request))
                        }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.fetchRequests()
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            navigationPath.append(.myPastBookings(viewModel.myUserId))
                        } label: {
                            Image("previous-date", bundle: nil)
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                    }
                }
                
                if viewModel.requests.isEmpty {
                    CMEmptyView(imageName: "empty", message: "No booking requests")
                }
            }
            .navigationTitle("My bookings")
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.bookingDetails(let request):
                    BookingStatusView(request: request, navigationPath: $navigationPath)
                case ScreenNames.myPastBookings(let myUserId):
                    MyPastBookingsView(myUserId: myUserId, navigationPath: $navigationPath)
                default:
                    fatalError()
                }
            }
        }
        .onAppear() {
            viewModel.fetchRequests()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return MyBookingsView(myUserId: "65971589d4f4d7af9f97a3bc")
}
