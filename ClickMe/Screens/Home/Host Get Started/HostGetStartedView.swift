//
//  HostGetStartedView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct HostGetStartedView: View {
    @Binding var isShowingGetStarted: Bool
    @AppStorage("hasShownGetStartedScreen") var hasShownGetStartedScreen: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()
            
            Text("Become a ClickMe host")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Share your knowledge, shine your light! Earn money in your leisure time and build connections. Meet people all over the world!")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Image("host", bundle: nil)
                .resizable()
                .scaledToFill()
                .frame(height: 250)
            Spacer()
            Button {
                isShowingGetStarted = false
                hasShownGetStartedScreen = true
            } label: {
                CMButton(title: "Get started", fullWidth: true)
            }
            Spacer()
        }
        .padding(.horizontal, 40)
        .navigationBarHidden(true)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                isShowingGetStarted = false
            }, label: {
                CMXButton()
            })
            .padding([.top, .trailing], 10)
        }
    }
}

#Preview {
    HostGetStartedView(isShowingGetStarted: .constant(true))
}
