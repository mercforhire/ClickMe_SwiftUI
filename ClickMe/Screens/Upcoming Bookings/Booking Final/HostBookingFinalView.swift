//
//  HostBookingFinalView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import SwiftUI

struct HostBookingFinalView: View {
    @Binding var navigationPath: [ScreenNames]
    @StateObject var viewModel: HostBookingFinalViewModel
    
    init(action: BookingAction, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: HostBookingFinalViewModel(action: action))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(viewModel.actionImageName, bundle: nil)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            Text(viewModel.actionSentence)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 20)
            Spacer()
            Button {
                navigationPath.removeAll()
            } label: {
                CMButton(title: "Done", fullWidth: true)
            }
            .padding(.top, 20)
        }
        .padding(.all, 20)
        .navigationBarHidden(true)
    }
}

#Preview {
    HostBookingFinalView(action: .accept, navigationPath: .constant([]))
}
