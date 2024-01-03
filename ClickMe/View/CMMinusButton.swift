//
//  CMMinusButton.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI

struct CMMinusButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
            Image(systemName: "minus")
                .imageScale(.medium)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CMMinusButton()
}
