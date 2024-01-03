//
//  HomeView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Home screen")
            .onAppear {
                UserManager.shared.logout()
            }
    }
}

#Preview {
    HomeView()
}
