//
//  ChatMessageRightView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import SwiftUI

struct ChatMessageRightView: View {
    var message: String
    var createdDate: Date
    var userProfile: UserProfile
    var showTimeStamp: Bool
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .trailing) {
                Text(message)
                    .font(.body)
                    .fontWeight(.regular)
                    .padding(.all, 10)
                    .foregroundColor(.white)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if showTimeStamp {
                    Text(Utils.timeAgoSince(createdDate))
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(Color(.systemGray))
                        .frame(height: 10, alignment: .trailing)
                }
            }
            
            if let urlString = userProfile.avatarThumbnailUrl {
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
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    VStack {
        ChatMessageRightView(message: MockData.mockShortMessage().message ?? "",
                             createdDate: MockData.mockShortMessage().createdDate,
                             userProfile: MockData.mockProfile(),
                             showTimeStamp: true)
        ChatMessageRightView(message: MockData.mockLongMessage().message ?? "", 
                             createdDate: MockData.mockLongMessage().createdDate,
                             userProfile: MockData.mockProfile(),
                             showTimeStamp: true)
    }
}
