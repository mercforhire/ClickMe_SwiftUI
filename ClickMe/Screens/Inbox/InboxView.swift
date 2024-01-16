//
//  InboxView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct InboxView: View {
    @Binding var newPerson: UserProfile?
    
    @StateObject private var viewModel: InboxViewModel
    @State private var navigationPath: [ScreenNames] = []
    
    init(myProfile: UserProfile, talkTo: Binding<UserProfile?>) {
        _viewModel = StateObject(wrappedValue: InboxViewModel(myProfile: myProfile))
        self._newPerson = talkTo
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List(viewModel.conversations, id: \.self) { conversation in
                    ChatConversationView(conversation: conversation, 
                                         currentUserId: viewModel.myProfile.userId)
                        .onTapGesture {
                            newPerson = nil
                            viewModel.selectedConversation = conversation
                            if let userToTalkTo = viewModel.getOtherConversationParticipant() {
                                navigationPath.append(.chat(userToTalkTo))
                            }
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
                case ScreenNames.chat(let userToTalkTo):
                    ChatView(myProfile: viewModel.myProfile, talkingTo: userToTalkTo)
                case ScreenNames.usersList(let type):
                    UsersListView(myProfile: viewModel.myProfile, type: type)
                default:
                    fatalError()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "person.fill.xmark") {
                        navigationPath.append(.usersList(.blockedUsers))
                    }
                }
            }
            .onChange(of: newPerson) { userToTalkTo in
                if let userToTalkTo {
                    navigationPath.removeAll()
                    navigationPath.append(.chat(userToTalkTo))
                }
            }
            .onAppear {
                viewModel.fetchConversations()
                
                if viewModel.firstTime, let userToTalkTo = newPerson {
                    navigationPath.append(.chat(userToTalkTo))
                }
                viewModel.firstTime = false
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return InboxView(myProfile: MockData.mockProfile(), talkTo: .constant(nil))
}
