//
//  ChatView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    
    init(myProfile: UserProfile, talkingTo: UserProfile) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(myProfile: myProfile, talkingTo: talkingTo))
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    ScrollViewReader { (proxy: ScrollViewProxy) in
                        MessagesListView(messages: viewModel.messages,
                                         myProfile: viewModel.myProfile,
                                         talkingTo: viewModel.talkingTo,
                                         scrollToBottom: $viewModel.scrollToBottom,
                                         scrollViewProxy: proxy) {
                            viewModel.fetchMessages()
                        }
                    }
                    
                    if viewModel.messages.isEmpty {
                        CMEmptyView(imageName: "sad", message: "No messages")
                    }
                }
                
                HStack {
                    TextField(viewModel.otherPersonBlockedMe ? "Other person blocked you" : "Message...",
                              text: $viewModel.typingMessage,
                              axis: .vertical)
                    .font(.title3)
                    .fontWeight(.light)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.sentences)
                    .lineLimit(5)
                    .keyboardType(.default)
                    .disabled(viewModel.otherPersonBlockedMe || viewModel.isSending)
                    
                    Button {
                        viewModel.sendChatMessage()
                    } label: {
                        Text(viewModel.isSending ? "Sending" : "Send")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.accent)
                    }
                    .disabled(viewModel.typingMessage.isEmpty || viewModel.isSending || viewModel.otherPersonBlockedMe)
                    .opacity((viewModel.typingMessage.isEmpty || viewModel.isSending) ? 0.5 : 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, -5)
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("\(viewModel.talkingTo.firstName ?? "Chat")" + (viewModel.blocked ? "-(Blocked)" : ""))
        .onAppear {
            viewModel.getBlockStatus()
            viewModel.startRefreshTimer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: viewModel.blocked ? "person.fill.checkmark" : "person.slash.fill") {
                    viewModel.handleBlockButton()
                }
                .tint(viewModel.blocked ? Color.green : Color.red)
            }
        }
        .onDisappear {
            viewModel.stopRefreshTime()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return NavigationView {
        ChatView(myProfile: MockData.mockProfile(), talkingTo: MockData.mockProfile2())
    }
}

struct MessagesListView: View {
    var messages: [Message]
    var myProfile: UserProfile
    var talkingTo: UserProfile
    @Binding var scrollToBottom: Bool
    var scrollViewProxy: ScrollViewProxy
    var refreshHandler: () -> Void
    
    private var participants: [UserProfile] {
        return [myProfile, talkingTo]
    }
    
    var body: some View {
        List(messages, id: \.self) { message in
            let messageString = message.getDisplayMessage(participants: participants)
            let showTimeStamp = message == messages.last
            
            if message.fromUserId == myProfile.userId {
                ChatMessageRightView(message: messageString,
                                     createdDate: message.createdDate,
                                     userProfile: myProfile,
                                     showTimeStamp: showTimeStamp)
                .listRowSeparator(.hidden)
            } else {
                ChatMessageLeftView(message: messageString,
                                    createdDate: message.createdDate,
                                    userProfile: talkingTo,
                                    showTimeStamp: showTimeStamp)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
        .refreshable(action: {
            refreshHandler()
        })
        .onChange(of: scrollToBottom) { _ in
            if let last = messages.last {
                scrollViewProxy.scrollTo(last, anchor: .bottom)
            }
        }
    }
}
