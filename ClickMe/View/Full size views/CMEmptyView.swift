//
//  CMEmptyView.swift
//  Appetizers
//
//  Created by Leon Chen on 2023-11-28.
//

import SwiftUI

struct CMEmptyView: View {
    @State var imageName: String = "404"
    @State var message: String = "No search results"
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 225)
                Text(message)
                    .foregroundStyle(.secondary)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .offset(y: -50)
        }
    }
}

#Preview {
    CMEmptyView(imageName: "404",
                message: "No search results")
}
