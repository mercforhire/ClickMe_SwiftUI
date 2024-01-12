//
//  ErrorView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct ErrorView: View {
    var retryHandler: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("bad", bundle: nil)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 200)
            Text("Error loading content")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            Button {
                retryHandler()
            } label: {
                Text("Retry")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ErrorView(retryHandler: {})
}
