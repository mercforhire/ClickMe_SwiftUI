//
//  InboxView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct InboxView: View {
    @Binding var talkTo: UserProfile?
    
    @StateObject private var viewModel: InboxViewModel
    @State private var navigationPath: [ScreenNames] = []
    
    init(myProfile: UserProfile, talkTo: Binding<UserProfile?>) {
        _viewModel = StateObject(wrappedValue: InboxViewModel(myProfile: myProfile))
        self._talkTo = talkTo
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List(viewModel.conversations, id: \.id) { conversation in
                    ChatConversationView(conversation: conversation, currentUserId: viewModel.myProfile.userId)
                        .onTapGesture {
                            viewModel.selectedConversation = conversation
                            talkTo = viewModel.getOtherConversationParticipant()
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
                    if let talkingTo = talkTo {
                        ChatView(myProfile: viewModel.myProfile, talkingTo: talkingTo)
                    }
                default:
                    fatalError()
                }
            }
            .onChange(of: talkTo) { userToTalkTo in
                if userToTalkTo != nil {
                    navigationPath.append(.chat)
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
    return InboxView(myProfile: UserProfile.mockProfile(), talkTo: .constant(nil))
}
