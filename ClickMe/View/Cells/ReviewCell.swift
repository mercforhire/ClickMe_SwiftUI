//
//  ReviewCell.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import SwiftUI

struct ReviewCell: View {
    var review: Review
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 10) {
                if let profile = review.reviewer, let urlString = profile.avatarThumbnailUrl {
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
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text((profile.firstName ?? ""))
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                MyCosmosView(rating: .constant(review.rating), 
                             tintColor: .systemYellow,
                             starSize: 20)
                    .frame(height: 20)
            }
            
            Divider()
                .frame(height: 1)
                .overlay(.primary)
 
            Text(review.comment)
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding(.all, 20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ReviewCell(review: MockData.mockReview())
}
