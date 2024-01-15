//
//  HostAccountView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import SwiftUI

enum HostAccountMenu: Int, Identifiable {
    case wallet
    case switchMode
    case support
    case feedback
    case signOut
    
    var id: HostAccountMenu { self }
    
    static func list() -> [HostAccountMenu] {
        return [.switchMode, .wallet, .support, .feedback, .signOut]
    }
    
    func text() -> String {
        switch self {
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
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: HostAccountViewModel(myProfile: myProfile))
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
                        
                        Text("\(viewModel.myProfile.firstName ?? "") \(viewModel.myProfile.lastName ?? "")")
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
                    
                    Section {
                        ForEach(HostAccountMenu.list(), id: \.self) { row in
                            Label(row.text(), systemImage: row.iconName())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    switch row {
                                    case .wallet:
                                        break
                                    case .switchMode:
                                        viewModel.handleSwitchMode()
                                    case .support:
                                        break
                                    case .feedback:
                                        viewModel.isPostingFeedback = true
                                    case .signOut:
                                        viewModel.handleLogOut()
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
            }
            .navigationTitle("My profile")
            .background(Color(.systemGray6))
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.editProfile:
                    EditProfileView(myProfile: viewModel.myProfile, navigationPath: $navigationPath)
                default:
                    fatalError()
                }
            }
        }
        .task {
            viewModel.refreshData()
        }
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(myProfile: viewModel.myProfile,
                            profile: viewModel.myProfile,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: false)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notifications.RefreshProfile), perform: { notification in
            viewModel.refreshData()
        })
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    return HostAccountView(myProfile: MockData.mockProfile2())
}
