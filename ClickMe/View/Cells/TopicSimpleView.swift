//
//  TopicSimpleView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct TopicSimpleView: View {
    var topic: Topic
    
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
                        .frame(width: 50, height: 50)
                }
                Text(topic.title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                Text(topic.displayablePrice)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
        }
        .padding(.all, 20)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    TopicSimpleView(topic: MockData.mockTopic())
}
