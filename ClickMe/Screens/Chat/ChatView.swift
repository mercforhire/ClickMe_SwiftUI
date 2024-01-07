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
                ScrollViewReader { (proxy: ScrollViewProxy) in
                    List(viewModel.messages, id: \.id) { message in
                        if message.fromUserId == viewModel.myProfile.userId {
                            ChatMessageRightView(message: message,
                                                 userProfile: viewModel.myProfile,
                                                 showTimeStamp: message == viewModel.messages.last)
                            .listRowSeparator(.hidden)
                        } else {
                            ChatMessageLeftView(message: message,
                                                userProfile: viewModel.talkingTo,
                                                showTimeStamp: message == viewModel.messages.last)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.fetchMessages()
                    }
                    .onChange(of: viewModel.scrollToBottom) { _ in
                        if let last = viewModel.messages.last {
                            proxy.scrollTo(last.id, anchor: .top)
                        }
                    }
                }
                
                HStack {
                    TextField("Message...", text: $viewModel.typingMessage, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.sentences)
                        .lineLimit(4)
                        .keyboardType(.default)
                        .frame(minHeight: CGFloat(30))
                    
                    Button {
                        viewModel.sendChatMessage()
                    } label: {
                        Text(viewModel.isSending ? "Sending" : "Send")
                            .foregroundStyle(.accent)
                    }
                    .disabled(viewModel.typingMessage.isEmpty || viewModel.isSending)
                    .opacity((viewModel.typingMessage.isEmpty || viewModel.isSending) ? 0.5 : 1)
                }.frame(minHeight: CGFloat(50)).padding()
            }
            
            if viewModel.messages.isEmpty {
                CMEmptyView(imageName: "sad", message: "No messages")
            }
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle(viewModel.talkingTo.firstName ?? "Chat")
        .onAppear {
            viewModel.fetchMessages()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return ChatView(myProfile: UserProfile.mockProfile(), talkingTo: UserProfile.mockProfile2())
}
