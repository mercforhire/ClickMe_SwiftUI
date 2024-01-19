//
//  CallingButtonView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import SwiftUI

struct CallingButtonView: View {
    var body: some View {
        ZStack {
            Image(systemName: "iphone.homebutton.radiowaves.left.and.right")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color(.systemBackground))
                .frame(width: 50, height: 50)
                .padding(.all, 10)
        }
        .background(.accent)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CallingButtonView()
}
