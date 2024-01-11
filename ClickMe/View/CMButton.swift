//
//  CMButton.swift
//  Appetizers
//
//  Created by Leon Chen on 2023-11-27.
//

import SwiftUI

struct CMButton: View {
    var title: LocalizedStringKey
    var fullWidth: Bool = false
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(height: 50)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: fullWidth ? .infinity : nil)
        .background(Color.accentColor)
        .cornerRadius(10)
    }
}

#Preview {
    CMButton(title: "Button")
}
