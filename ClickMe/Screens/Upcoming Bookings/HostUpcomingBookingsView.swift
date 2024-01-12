//
//  HostUpcomingBookingsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct HostUpcomingBookingsView: View {
    @StateObject var viewModel: HostUpcomingBookingsViewModel
    @State private var navigationPath: [ScreenNames] = []
    
    init(myUserId: String) {
        _viewModel = StateObject(wrappedValue: HostUpcomingBookingsViewModel(myUserId: myUserId))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List(viewModel.requests, id: \.id) { request in
                    BookingRequestView(request: request)
                        .frame(height: 300)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            navigationPath.append(.hostRequestOverview(request))
                        }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.fetchRequests()
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            navigationPath.append(.hostPastBookings(viewModel.myUserId))
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
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationTitle("Upcoming bookings")
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.hostPastBookings(let userId):
                    PastHostingsView(myUserId: userId, navigationPath: $navigationPath)
                case ScreenNames.hostRequestOverview(let request):
                    HostRequestView(request: request, navigationPath: $navigationPath)
                case ScreenNames.hostBookingFinal(let action):
                    HostBookingFinalView(action: action, navigationPath: $navigationPath)
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
    ClickAPI.shared.apiKey = "00bdda2d44401b66b309bec2ec3d7e4ae6b975b2824fd4f814f11023369886cb83e005e5a1fc97b783bd4110e948bd345053c364b50a84cc48245d4d0de380a8"
    return HostUpcomingBookingsView(myUserId: MockData.mockProfile2().userId)
}
