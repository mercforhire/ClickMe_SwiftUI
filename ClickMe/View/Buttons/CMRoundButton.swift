//
//  CMRoundButton.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import SwiftUI

struct CMRoundButton: View {
    @State var iconName: String
    
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
            Image(systemName: iconName)
                .imageScale(.large)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    ZStack {
        CMRoundButton(iconName: "mic.slash.fill")
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
