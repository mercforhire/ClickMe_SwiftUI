//
//  HostPastBookingsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct PastHostingsView: View {
    @StateObject var viewModel: PastHostingsViewModel
    @Binding private var navigationPath: [ScreenNames]
    
    init(myProfile: UserProfile, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: PastHostingsViewModel(myProfile: myProfile))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
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
            
            if viewModel.requests.isEmpty {
                CMEmptyView(imageName: "empty", message: "No past hostings")
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Past hostings")
        .onAppear() {
            viewModel.fetchRequests()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "00bdda2d44401b66b309bec2ec3d7e4ae6b975b2824fd4f814f11023369886cb83e005e5a1fc97b783bd4110e948bd345053c364b50a84cc48245d4d0de380a8"
    return PastHostingsView(myProfile: MockData.mockProfile2(),
                            navigationPath: .constant([.hostPastBookings]))
}
