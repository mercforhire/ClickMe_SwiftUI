//
//  CMFollowButton.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct CMFollowButton: View {
    var following: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 50)
                .foregroundColor(.accentColor)
            Image(systemName: following ? "person.2.slash.fill" : "person.line.dotted.person.fill")
                .imageScale(.large)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CMFollowButton(following: false)
}
