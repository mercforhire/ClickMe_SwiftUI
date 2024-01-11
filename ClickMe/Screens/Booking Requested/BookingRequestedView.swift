//
//  BookingRequestedView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct BookingRequestedView: View {
    @Binding var navigationPath: [ScreenNames]
    
    init(navigationPath: Binding<[ScreenNames]>) {
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("time", bundle: nil)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
            Text("Your request has been sent")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text("The ClickMe host will make a decision soon.")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
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
    BookingRequestedView(navigationPath: .constant([]))
}
