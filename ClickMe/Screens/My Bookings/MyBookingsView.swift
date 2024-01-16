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
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: MyBookingsViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List(viewModel.requests, id: \.id) { request in
                    BookingRequestView(request: request)
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
                            navigationPath.append(.myPastBookings)
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
                    BookingStatusView(myProfile: viewModel.myProfile, request: request, navigationPath: $navigationPath)
                case ScreenNames.myPastBookings:
                    MyPastBookingsView(myProfile: viewModel.myProfile, navigationPath: $navigationPath)
                case ScreenNames.checkOut(let stripeData):
                    CheckOutView(stripeData: stripeData)
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
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return MyBookingsView(myProfile: MockData.mockProfile())
}
