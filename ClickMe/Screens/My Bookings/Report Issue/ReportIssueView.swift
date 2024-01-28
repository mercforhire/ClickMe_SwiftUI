//
//  ReportIssueView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-26.
//

import SwiftUI

struct ReportIssueView: View {
    @StateObject var viewModel: ReportIssueViewModel
    
    init(myUserId: String, host: UserProfile, topic: Topic, request: Request, receipt: Receipt?) {
        _viewModel = StateObject(wrappedValue: ReportIssueViewModel(myUserId: myUserId, host: host, topic: topic, request: request, receipt: receipt))
    }
    
    var body: some View {
        ZStack {
            Form {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 10) {
                        if let urlString = viewModel.host.avatarUrl {
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
                        
                        Text(viewModel.host.fullName)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .padding(.all, 10)
                    
                    Divider()
                        .frame(height: 5)
                        .overlay(Color(.systemGray6))
                    
                    Text(viewModel.topic.title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                }
                
                if let receipt = viewModel.receipt {
                    Section("Booking details") {
                        VStack(alignment: .leading) {
                            Text(viewModel.request.timeAndDuration)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Booking date")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Text(viewModel.request.createdDateDisplayable)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Confirmation code")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .textSelection(.enabled)
                            
                            Text(receipt._id)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Paid")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Text(receipt.amountDisplayable)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                VStack {
                    if let actionError = viewModel.actionError {
                        CMErrorLabel(actionError)
                            .padding(.horizontal, 10)
                    }
                    Button {
                        viewModel.isShowingReportIssue = true
                    } label: {
                        CMButton(title: "Report issue", fullWidth: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.all, 10)
                }
                
                if !viewModel.issues.isEmpty {
                    Section("Reported issues") {
                        ForEach(viewModel.issues, id: \.id) { issue in
                            Text(issue.issueDetail)
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .blur(radius: viewModel.isShowingReportIssue ? 20 : 0)
            .disabled(viewModel.isShowingReportIssue)
            
            if viewModel.isShowingReportIssue {
                TextFieldActionView(buttonText: "Submit",
                                    placeholder: "Please describe the issue and we will get back to you",
                                    isShowingView: $viewModel.isShowingReportIssue) { message in
                    viewModel.handleSubmitAction(message: message)
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Report an issue")
        .onAppear() {
            viewModel.fetchIssues()
        }
    }
}

#Preview {
    ReportIssueView(myUserId: MockData.mockUser().apiKey, 
                    host: MockData.mockProfile2(),
                    topic: MockData.mockTopic(),
                    request: MockData.mockRequest3(),
                    receipt: MockData.mockReceipt())
}
