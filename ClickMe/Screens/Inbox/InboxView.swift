//
//  InboxView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct InboxView: View {
    var currentUserId: String
    @StateObject var viewModel = InboxViewModel()
    
    @State private var navigationPath: [ScreenNames] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List(viewModel.conversations, id: \.id) { conversation in
                    ChatConversationView(conversation: conversation, currentUserId: currentUserId)
                        .onTapGesture {
                            viewModel.selectedConversation = conversation
                            navigationPath.append(.chat)
                        }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    viewModel.fetchConversations()
                }
                if viewModel.conversations.isEmpty {
                    CMEmptyView(imageName: "sad", message: "No conversations")
                }
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationTitle("Chat")
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.chat:
                    if let myProfile = viewModel.myProfile, let talkingTo = viewModel.talkingTo {
                        ChatView(myProfile: myProfile, talkingTo: talkingTo)
                    }
                default:
                    fatalError()
                }
            }
        }
        .onAppear {
            viewModel.fetchConversations()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return InboxView(currentUserId: "6599a7185c1c5add1b6aa587")
}
