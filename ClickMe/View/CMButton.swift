//
//  CMButton.swift
//  Appetizers
//
//  Created by Leon Chen on 2023-11-27.
//

import SwiftUI

struct CMButton: View {
    var title: LocalizedStringKey
    var width: CGFloat = 260
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: width, height: 50)
            .foregroundStyle(.white)
            .background(Color.accentColor)
            .cornerRadius(10)
    }
}

#Preview {
    CMButton(title: "Button")
}
