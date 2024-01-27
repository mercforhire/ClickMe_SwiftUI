//
//  ReportIssueViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-26.
//

import Foundation

@MainActor
final class ReportIssueViewModel: ObservableObject {
    var myUserId: String
    var host: UserProfile
    var topic: Topic
    var request: Request
    var receipt: Receipt?
    
    @Published var isLoading = false
    @Published var issues: [Issue] = []
    @Published var isShowingReportIssue = false
    @Published var actionError: String?
    
    init(myUserId: String, host: UserProfile, topic: Topic, request: Request, receipt: Receipt?) {
        self.myUserId = myUserId
        self.host = host
        self.topic = topic
        self.request = request
        self.receipt = receipt
    }
    
    func fetchIssues() {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.getIssueReports(requestId: request._id)
            if let issues = response?.data?.issues {
                self.issues = issues
            }
            isLoading = false
        }
    }
    
    func handleSubmitAction(message: String) {
        isLoading = true
        Task {
            let response = try? await ClickAPI.shared.createIssue(requestId: request._id, issueDetail: message)
            if response?.success ?? false{
                fetchIssues()
            } else {
                actionError = "Unknown error during submission"
                isLoading = false
            }
        }
    }
}
