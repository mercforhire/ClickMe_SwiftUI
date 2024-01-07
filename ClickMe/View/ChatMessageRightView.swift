//
//  ChatMessageRightView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import SwiftUI

struct ChatMessageRightView: View {
    var message: Message
    var userProfile: UserProfile
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .trailing) {
                Text(message.message ?? "")
                    .font(.body)
                    .fontWeight(.regular)
                    .padding(.all, 10)
                    .frame(minHeight: 80)
                    .foregroundColor(.primary)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(Utils.timeAgoSince(message.createdDate))
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(Color(.systemGray))
                    .frame(height: 10, alignment: .trailing)
            }
            
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
                .padding(.bottom, 18)
            } else {
                Image("male-l", bundle: nil)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    VStack {
        ChatMessageRightView(message: Message.mockShortMessage(), userProfile: UserProfile.mockProfile())
        ChatMessageRightView(message: Message.mockLongMessage(), userProfile: UserProfile.mockProfile())
    }
}
