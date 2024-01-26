//
//  HostAccountView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import SwiftUI

enum HostAccountMenu: Int, Identifiable {
    case payout
    case wallet
    case switchMode
    case support
    case feedback
    case signOut
    
    var id: HostAccountMenu { self }
    
    static func list() -> [HostAccountMenu] {
        return [.switchMode, .payout, .wallet, .support, .feedback, .signOut]
    }
    
    func text() -> String {
        switch self {
        case .payout:
            return "Payout setup"
        case .switchMode:
            return "Switch to guest"
        case .wallet:
            return "My wallet"
        case .support:
            return "Support & FAQ"
        case .feedback:
            return "Feedback"
        case .signOut:
            return "Sign out"
        }
    }
    
    func iconName() -> String {
        switch self {
        case .payout:
            return "creditcard"
        case .wallet:
            return "dollarsign.circle"
        case .switchMode:
            return "arrow.2.squarepath"
        case .support:
            return "questionmark.circle"
        case .feedback:
            return "star.bubble"
        case .signOut:
            return "rectangle.portrait.and.arrow.right"
        }
    }
}

struct HostAccountView: View {
    @StateObject var viewModel: HostAccountViewModel
    @State private var navigationPath: [ScreenNames] = []
    @EnvironmentObject var agora: AgoraManager
    
    init(myUser: User, myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: HostAccountViewModel(myUser: myUser, myProfile: myProfile))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Form {
                    VStack(alignment: .center) {
                        if let urlString = viewModel.myProfile.avatarUrl {
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
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .clipped()
                        }
                        
                        Text(viewModel.myProfile.fullName)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.bottom, 5)
                        
                        Text("\(viewModel.myProfile.jobTitle ?? "") at \(viewModel.myProfile.company ?? "")")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .padding(.bottom, 5)
                            .multilineTextAlignment(.center)
                        
                        Text("ID: \(viewModel.myProfile.screenId)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 5)
                            .textSelection(.enabled)
                        
                        HStack(spacing: 10) {
                            Button {
                                viewModel.isShowingProfile = true
                            } label: {
                                CMButton(title: "View profile")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button {
                                navigationPath.append(.editProfile)
                            } label: {
                                CMButton(title: "Edit profile")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Section {
                        ForEach(HostAccountMenu.list(), id: \.self) { row in
                            Label(row.text(), systemImage: row.iconName())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    switch row {
                                    case .payout:
                                        navigationPath.append(.stripeConnectSetup)
                                    case .wallet:
                                        navigationPath.append(.wallet)
                                    case .switchMode:
                                        if agora.inInACall {
                                            viewModel.isShowingInACallDialog = true
                                        } else {
                                            viewModel.handleSwitchMode()
                                        }
                                    case .support:
                                        break
                                    case .feedback:
                                        viewModel.isPostingFeedback = true
                                    case .signOut:
                                        if agora.inInACall {
                                            viewModel.isShowingInACallDialog = true
                                        } else {
                                            viewModel.handleLogOut()
                                        }
                                    }
                                }
                        }
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
                
                //https://stackoverflow.com/questions/59116198/multiple-alerts-in-one-view-can-not-be-called-swiftui
                Text("")
                    .alert("Submit feedback", isPresented: $viewModel.isPostingFeedback) {
                        TextField("Message", text: $viewModel.feedback)
                        Button("Send") {
                            viewModel.handlePostFeedback()
                            viewModel.isPostingFeedback = false
                        }
                        Button("Cancel", role: .cancel) {
                            viewModel.isPostingFeedback = false
                            viewModel.feedback = ""
                        }
                    }
                
                Text("")
                    .alert(isPresented: $viewModel.postFeedbackSuccess) {
                        Alert(title: Text("Feedback sent"),
                              message: Text("Thank you for your feedback"),
                              dismissButton: .default(Text("Ok")))
                    }
                    
                Text("")
                    .alert(isPresented: $viewModel.postFeedbackError) {
                        Alert(title: Text("Feedback error"),
                              message: Text("Failed to sent feedback"),
                              dismissButton: .default(Text("Ok")))
                    }
                
                Text("")
                    .alert("Sorry, can't perform this action during a call.", isPresented: $viewModel.isShowingInACallDialog) {
                        Button("Dismiss") {}
                    }
            }
            .navigationTitle("My profile")
            .background(Color(.systemGray6))
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.editProfile:
                    EditProfileView(myProfile: viewModel.myProfile, navigationPath: $navigationPath)
                case ScreenNames.wallet:
                    WalletView(myProfile: viewModel.myProfile, navigationPath: $navigationPath)
                case ScreenNames.receiptDetails(let receipt):
                    ReceiptDetailsView(myProfile: viewModel.myProfile, receipt: receipt)
                case ScreenNames.stripeConnectSetup:
                    ConnectSetupView(myUser: viewModel.myUser, myProfile: viewModel.myProfile, navigationPath: $navigationPath)
                default:
                    fatalError()
                }
            }
            .onAppear {
                viewModel.refreshData()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(myProfile: viewModel.myProfile,
                            profile: viewModel.myProfile,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: false)
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    return HostAccountView(myUser: MockData.mockUser2(), myProfile: MockData.mockProfile2())
        .environmentObject({() -> AgoraManager in
            let agora = AgoraManager()
            return agora
        }())
}
