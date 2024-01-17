//
//  CMFollowButton.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct CMFollowButton: View {
    @State var following: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 50)
                .foregroundColor(.accentColor)
            Image(systemName: following ? "person.badge.minus" : "person.badge.plus")
                .imageScale(.large)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CMFollowButton(following: false)
}
