//
//  AccountViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import Foundation

@MainActor
final class AccountViewModel: ObservableObject {
    var myUser: User
    @Published var myProfile: UserProfile
    @Published var isLoading = false
    @Published var isShowingProfile = false
    @Published var isPostingFeedback = false
    @Published var feedback: String = ""
    @Published var postFeedbackSuccess = false
    @Published var postFeedbackError = false
    @Published var isShowingDeleteAccountDialog = false
    @Published var deleteDialogText: String = ""
    @Published var deleteAccountError = false
    @Published var isShowingInACallDialog = false
    
    init(myUser: User, myProfile: UserProfile) {
        self.myUser = myUser
        self.myProfile = myProfile
    }
    
    func refreshData() {
        Task {
            let response = try? await ClickAPI.shared.getUserProfile(userId: myProfile.id)
            if let profile = response?.data?.profile {
                self.myProfile = profile
                UserManager.shared.set(profile: profile)
            }
        }
    }
    
    func handlePostFeedback() {
        guard !feedback.isEmpty else { return }
        
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.postFeedback(message: feedback)
            if response?.success ?? false {
                feedback = ""
                postFeedbackSuccess = true
            } else {
                postFeedbackError = true
            }
            isLoading = false
        }
    }
    
    func handleSwitchMode() {
        NotificationCenter.default.post(name: Notifications.ToggleGuestHostMode, object: nil, userInfo: nil)
    }
    
    func handleLogOut() {
        UserManager.shared.logout()
        NotificationCenter.default.post(name: Notifications.RefreshLoginStatus, object: nil, userInfo: nil)
    }
    
    func handleDeleteAccount() {
        guard deleteDialogText == "DELETE" else {
            deleteAccountError = true
            return
        }
        
        Task {
            isLoading = true
            let response = try? await ClickAPI.shared.deleteAccount()
            if response?.success ?? false {
                handleLogOut()
            }
            isLoading = false
        }
    }
}
