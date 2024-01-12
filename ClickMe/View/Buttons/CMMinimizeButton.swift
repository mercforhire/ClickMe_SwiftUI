//
//  CMMinimizeButton.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import SwiftUI

struct CMMinimizeButton: View {
    var body: some View {
        ZStack{
            Capsule()
                .frame(width: 50, height: 30)
                .foregroundColor(.white)
                .opacity(0.6)
            Image(systemName: "minus")
                .imageScale(.large)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    CMMinimizeButton()
}
