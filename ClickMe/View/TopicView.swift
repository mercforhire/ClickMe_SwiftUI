//
//  TopicView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct TopicView: View {
    var topic: Topic
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(topic.mood.text())")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(topic.mood.imageName(), bundle: nil)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 50)
                }
                Text(topic.title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(topic.displayablePrice)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
            }
            .frame(width: width, height: height)
            .padding(.all, 20)
        }
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    TopicView(topic: Topic.mockTopic(), width: 250, height: 200)
}
