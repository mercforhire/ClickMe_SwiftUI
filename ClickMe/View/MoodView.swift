//
//  MoodView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import SwiftUI

struct MoodView: View {
    var mood: Mood
    var width: CGFloat
    var height: CGFloat
    var selected: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Image(mood.imageName(), bundle: nil)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(mood.text())
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(selected ? .white : .primary)
            }
            .padding(5)
        }
        .frame(width: width, height: height)
        .background(selected ? .accentColor : Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    MoodView(mood: .advance, width: 200, height: 100, selected: false)
}
