//
//  ChatConversationView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import SwiftUI

struct ChatConversationView: View {
    var conversation: Conversation
    var currentUserId: String
    @State var theOtherUser: UserProfile?
    
    var body: some View {
        HStack(alignment: .top) {
            if let theOtherUser = theOtherUser {
                if let urlString = theOtherUser.userPhotos?.first?.thumbnail  {
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
                        Text("\(theOtherUser.firstName ?? "") \(theOtherUser.lastName ?? "")")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(Utils.timeAgoSince(conversation.lastMessageDate))
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(Color(.systemGray))
                            .frame(maxWidth: 100)
                    }
                    
                    Text(conversation.lastMessage.messageString)
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .lineLimit(4)
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
        for participant in conversation.participants {
            if participant.userId != currentUserId {
                return participant
            }
        }
        return nil
    }
}

#Preview {
    ChatConversationView(conversation: Conversation.mockConversation(),
                         currentUserId: "65971589d4f4d7af9f97a3bc")
}
