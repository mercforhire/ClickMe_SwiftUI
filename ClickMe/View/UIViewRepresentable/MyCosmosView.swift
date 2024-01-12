//
//  MyCosmosView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation
import SwiftUI
import Cosmos

// A SwiftUI wrapper for Cosmos view
struct MyCosmosView: UIViewRepresentable {
    @Binding var rating: Double
    
    func makeUIView(context: Context) -> CosmosView {
        CosmosView()
    }
    
    func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating
        
        // Autoresize Cosmos view according to it intrinsic size
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // Change Cosmos view settings here
        uiView.settings.starSize = 30
        uiView.settings.filledColor = .white
        uiView.settings.emptyColor = .clear
        uiView.settings.emptyBorderColor = .white
        uiView.settings.filledBorderColor = .white
        uiView.settings.emptyBorderWidth = 1
    }
}

struct ContentView: View {
    @State var rating = 4.0
    
    var body: some View {
        ZStack {
            MyCosmosView(rating: $rating)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(Color.accentColor)
    }
}

#Preview {
    ContentView()
}
