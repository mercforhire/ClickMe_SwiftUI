//
//  ChatMessageLeftView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import Foundation
import SwiftUI

struct ChatMessageLeftView: View {
    var message: Message
    var userProfile: UserProfile
    var showTimeStamp: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            if let urlString = userProfile.userPhotos?.first?.thumbnail  {
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
            } else {
                Image("male-l", bundle: nil)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading) {
                Text(message.message ?? "")
                    .font(.body)
                    .fontWeight(.regular)
                    .padding(.all, 10)
                    .foregroundColor(.primary)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if showTimeStamp {
                    Text(Utils.timeAgoSince(message.createdDate))
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(Color(.systemGray))
                        .frame(height: 10, alignment: .leading)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    VStack {
        ChatMessageLeftView(message: Message.mockShortMessage(), userProfile: UserProfile.mockProfile(), showTimeStamp: true)
        ChatMessageLeftView(message: Message.mockLongMessage(), userProfile: UserProfile.mockProfile(), showTimeStamp: true)
    }
}
