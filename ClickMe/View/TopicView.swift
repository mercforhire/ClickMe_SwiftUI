//
//  TopicView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct TopicView: View {
    var topic: Topic
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 20) {
                if let profile = topic.userProfile, let urlString = profile.userPhotos?.first?.thumbnail {
                    AsyncImage(url: URL(string: urlString)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image("male-l", bundle: nil)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5)
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
                    VStack(alignment: .leading) {
                        Text("\(profile.firstName ?? "") \(profile.lastName ?? "")")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Text(profile.jobTitle ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                    }
                }
                Spacer()
                Image(topic.mood.imageName(), bundle: nil)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            }
            
            Divider()
                .frame(height: 1)
                .overlay(.primary)
            
            Text(topic.title)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .padding(.vertical, 5)
                .lineLimit(2)
            
            Text(topic.description)
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(.primary)
                .lineLimit(4)
            
            Spacer()
            
            Text(topic.displayablePrice)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)

        }
        .padding(.all, 20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    TopicView(topic: MockData.mockTopic())
}
