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
    private let screenHeight = UIScreen.main.bounds.size.height
    
    init(myProfile: UserProfile, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: PastHostingsViewModel(myProfile: myProfile))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.requests, id: \.self) { request in
                    BookingRequestView(request: request)
                        .frame(height: 300)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            navigationPath.append(.hostRequestOverview(request))
                        }
                }
                
                if viewModel.requests.isEmpty {
                    CMEmptyView(imageName: "empty", message: "No past hostings")
                        .padding(.top, screenHeight * 0.1)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.fetchRequests()
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
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return NavigationView {
        PastHostingsView(myProfile: MockData.mockProfile(),
                         navigationPath: .constant([.hostPastBookings]))
    }
}
