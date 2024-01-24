//
//  ChatConversationView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import SwiftUI

struct ChatConversationView: View {
    var currentUserId: String
    var conversation: Conversation
    @State var theOtherUser: UserProfile?
    
    var body: some View {
        HStack(alignment: .top) {
            if let theOtherUser = theOtherUser {
                if let urlString = theOtherUser.avatarThumbnailUrl {
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
                    HStack {
                        Text(theOtherUser.firstName ?? "")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(Utils.timeAgoSince(conversation.lastMessageDate))
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(Color(.systemGray))
                    }
                    
                    Text(conversation.lastMessage.getDisplayMessage(participants: conversation.participants))
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
            } else {
                LoadingView()
            }
        }
        .contentShape(Rectangle())
        .onAppear {
            theOtherUser = getTheOtherUser()
        }
    }
    
    func getTheOtherUser() -> UserProfile? {
        return conversation.participants.first(where: { $0.userId != currentUserId })
    }
}

#Preview {
    ChatConversationView(currentUserId: MockData.mockUser()._id,
                         conversation: MockData.mockConversation())
}
