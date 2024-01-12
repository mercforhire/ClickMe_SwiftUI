//
//  CMChatButton.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct CMChatButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 50)
                .foregroundColor(.accentColor)
            Image(systemName: "bubble")
                .imageScale(.large)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CMChatButton()
}
