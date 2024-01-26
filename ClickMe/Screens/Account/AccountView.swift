//
//  AccountView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import SwiftUI

enum AccountMenu: Int, Identifiable {
    case payments
    case history
    case switchMode
    case support
    case feedback
    case signOut
    case deleteAccount
    
    var id: AccountMenu { self }
    
    static func list() -> [AccountMenu] {
        return [.switchMode, .payments, .history, .support, .feedback, .signOut, .deleteAccount]
    }
    
    func text() -> String {
        switch self {
        case .switchMode:
            return "Switch to host"
        case .payments:
            return "Payment setup"
        case .history:
            return "Booking history"
        case .support:
            return "Support & FAQ"
        case .feedback:
            return "Feedback"
        case .signOut:
            return "Sign out"
        case .deleteAccount:
            return "Delete account"
        }
    }
    
    func iconName() -> String {
        switch self {
        case .payments:
            return "dollarsign.circle"
        case .history:
            return "clock.arrow.circlepath"
        case .switchMode:
            return "arrow.2.squarepath"
        case .support:
            return "questionmark.circle"
        case .feedback:
            return "star.bubble"
        case .signOut:
            return "rectangle.portrait.and.arrow.right"
        case .deleteAccount:
            return "trash"
        }
    }
}

struct AccountView: View {
    @StateObject var viewModel: AccountViewModel
    @State private var navigationPath: [ScreenNames] = []
    @EnvironmentObject var agora: AgoraManager
    
    init(myUser: User, myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: AccountViewModel(myUser: myUser, myProfile: myProfile))
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
                        
                        Text("ID: \(viewModel.myProfile.screenId)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 5)
                            .textSelection(.enabled)
                        
                        HStack(alignment: .center, spacing: 20) {
                            VStack {
                                Text("\(viewModel.myProfile.numberFollowing ?? 0)")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Text("Following")
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                            .onTapGesture {
                                print("Go to following screen")
                                navigationPath.append(.usersList(.following))
                            }
                            
                            Divider()
                                .frame(width: 1)
                                .overlay(Color.secondary)
                            
                            VStack {
                                Text("\(viewModel.myProfile.numberOfFollowers ?? 0)")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Text("Followers")
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                            .onTapGesture {
                                print("Go to followers screen")
                                navigationPath.append(.usersList(.followers))
                            }
                        }
                        .frame(height: 50)
                        
                        HStack(spacing: 20) {
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
                        ForEach(AccountMenu.list(), id: \.self) { row in
                            Label(row.text(), systemImage: row.iconName())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    switch row {
                                    case .payments:
                                        navigationPath.append(.stripeCustomerSetup)
                                    case .history:
                                        navigationPath.append(.myPastBookings)
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
                                    case .deleteAccount:
                                        if agora.inInACall {
                                            viewModel.isShowingInACallDialog = true
                                        } else {
                                            viewModel.isShowingDeleteAccountDialog = true
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
                    .alert("Are you sure? Type DELETE to confirm", isPresented: $viewModel.isShowingDeleteAccountDialog) {
                        TextField("Confirmation", text: $viewModel.deleteDialogText)
                        Button("Ok", role: .destructive) {
                            viewModel.handleDeleteAccount()
                            viewModel.isShowingDeleteAccountDialog = false
                        }
                        Button("Cancel", role: .cancel) {
                            viewModel.isShowingDeleteAccountDialog = false
                            viewModel.deleteDialogText = ""
                        }
                    }
                
                Text("")
                    .alert(isPresented: $viewModel.deleteAccountError) {
                        Alert(title: Text("Delete account error"),
                              message: Text("Invalid entry for confirmation"),
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
                case ScreenNames.myPastBookings:
                    MyPastBookingsView(myProfile: viewModel.myProfile, navigationPath: $navigationPath)
                case ScreenNames.editProfile:
                    EditProfileView(myProfile: viewModel.myProfile, navigationPath: $navigationPath)
                case ScreenNames.usersList(let type):
                    UsersListView(myProfile: viewModel.myProfile, type: type)
                case ScreenNames.stripeCustomerSetup:
                    CustomerSetupView(myUser: viewModel.myUser, myProfile: viewModel.myProfile, navigationPath: $navigationPath)
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
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return AccountView(myUser: MockData.mockUser(), myProfile: MockData.mockProfile())
        .environmentObject({() -> AgoraManager in
            let agora = AgoraManager()
            return agora
        }())
}
