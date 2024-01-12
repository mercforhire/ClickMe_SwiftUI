//
//  CMXButton.swift
//  Appetizers
//
//  Created by Leon Chen on 2023-11-27.
//

import SwiftUI

struct CMXButton: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .opacity(0.6)
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    CMXButton()
}
