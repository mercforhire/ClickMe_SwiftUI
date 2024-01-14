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
    var tintColor: UIColor = .white
    var starSize: CGFloat = 30
    
    func makeUIView(context: Context) -> CosmosView {
        CosmosView()
    }
    
    func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating
        
        // Autoresize Cosmos view according to it intrinsic size
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // Change Cosmos view settings here
        uiView.settings.starSize = starSize
        uiView.settings.filledColor = tintColor
        uiView.settings.emptyColor = .clear
        uiView.settings.emptyBorderColor = tintColor
        uiView.settings.filledBorderColor = tintColor
        uiView.settings.emptyBorderWidth = 1
        uiView.didFinishTouchingCosmos = { rating in
            self.rating = rating
        }
    }
}

struct ContentView: View {
    @State var rating = 4.0
    
    var body: some View {
        ZStack {
            MyCosmosView(rating: $rating, tintColor: .white, starSize: 20)
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
