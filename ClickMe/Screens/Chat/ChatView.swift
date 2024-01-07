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
                    
                    if viewModel.messages.isEmpty {
                        CMEmptyView(imageName: "sad", message: "No messages")
                    }
                }
                
                HStack {
                    TextField(viewModel.otherPersonBlockedMe ? "Other person blocked you" : "Message...",
                              text: $viewModel.typingMessage,
                              axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.sentences)
                        .lineLimit(4)
                        .keyboardType(.default)
                        .frame(minHeight: CGFloat(40))
                        .disabled(viewModel.otherPersonBlockedMe)
                    
                    Button {
                        viewModel.sendChatMessage()
                    } label: {
                        Text(viewModel.isSending ? "Sending" : "Send")
                            .foregroundStyle(.accent)
                    }
                    .disabled(viewModel.typingMessage.isEmpty || viewModel.isSending || viewModel.otherPersonBlockedMe)
                    .opacity((viewModel.typingMessage.isEmpty || viewModel.isSending) ? 0.5 : 1)
                    .frame(height: 30)
                }
                .frame(minHeight: CGFloat(50))
                .padding(.horizontal, 20)
                .padding(.top, -5)
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("\(viewModel.talkingTo.firstName ?? "Chat")" + (viewModel.blocked ? "-(Blocked)" : ""))
        .onAppear {
            viewModel.fetchMessages()
            viewModel.getBlockStatus()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: viewModel.blocked ? "person.fill.checkmark" : "person.slash.fill") {
                    viewModel.handleBlockButton()
                }
                .tint(viewModel.blocked ? Color.green : Color.red)
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return ChatView(myProfile: UserProfile.mockProfile(), talkingTo: UserProfile.mockProfile2())
}
