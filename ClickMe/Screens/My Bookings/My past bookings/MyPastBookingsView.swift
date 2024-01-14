//
//  MyPastBookingsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import SwiftUI

struct MyPastBookingsView: View {
    @StateObject var viewModel: MyPastBookingsViewModel
    @Binding var navigationPath: [ScreenNames]
    
    init(myProfile: UserProfile, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: MyPastBookingsViewModel(myProfile: myProfile))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
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
            if viewModel.requests.isEmpty {
                CMEmptyView(imageName: "empty", message: "No past booking requests")
            }
        }
        .navigationTitle("Past bookings")
        .onAppear() {
            viewModel.fetchRequests()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return MyPastBookingsView(myProfile: MockData.mockProfile(), navigationPath: .constant([]))
}
