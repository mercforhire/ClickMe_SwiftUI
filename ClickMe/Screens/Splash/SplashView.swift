//
//  SplashView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct SplashView: View {
    @State var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                GetStartedView()
            } else {
                Image("background", bundle: nil)
                    .resizable()
                    .ignoresSafeArea()
                Image("logo2", bundle: nil)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
