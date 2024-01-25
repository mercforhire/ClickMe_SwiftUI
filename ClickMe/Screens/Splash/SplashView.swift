//
//  SplashView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
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
}

#Preview {
    SplashView()
}
