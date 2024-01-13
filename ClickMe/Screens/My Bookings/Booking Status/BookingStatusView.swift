//
//  BookingStatusView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import SwiftUI

struct BookingStatusView: View {
    @StateObject var viewModel: BookingStatusViewModel
    @Binding var navigationPath: [ScreenNames]
    
    init(myProfile: UserProfile, request: Request, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: BookingStatusViewModel(myProfile: myProfile, request: request))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
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
                        
                        VStack(alignment: .leading) {
                            Text("\(viewModel.host.firstName ?? "") \(viewModel.host.lastName ?? "")")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(viewModel.host.jobTitle ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Text(viewModel.host.company ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.all, 10)
                    
                    HStack {
                        Button {
                            viewModel.isShowingProfile = true
                        } label: {
                            CMButton(title: "View profile")
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.handleChatButton()
                        } label: {
                            CMChatButton()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 10)
                    
                    Divider()
                        .frame(height: 5)
                        .overlay(Color(.systemGray6))
                    
                    HStack {
                        Image(viewModel.topic.mood.imageName(), bundle: nil)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                        
                        Text("\(viewModel.topic.mood.text())")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .padding(.all, 10)
                    
                    Text(viewModel.topic.title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    
                    Text(viewModel.topic.description)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    
                    Divider()
                        .frame(height: 5)
                        .overlay(Color(.systemGray6))
                    
                    Text(viewModel.request.timeAndDuration)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.all, 10)
                    
                    if let receipt = viewModel.receipt {
                        Text(receipt.displayablePrice)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .frame(height: 5)
                        .overlay(Color(.systemGray6))
                    
                    if let actionError = viewModel.actionError {
                        CMErrorLabel(actionError)
                            .padding(.horizontal, 10)
                    }
                    
                    if viewModel.request.status == .APPROVED {
                        Button {
                            
                        } label: {
                            CMButton(title: "Start call", fullWidth: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.all, 10)
                        
                        Button {
                            viewModel.isShowingCancelModal = true
                        } label: {
                            CMButton(title: "Cancel booking", fullWidth: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.all, 10)
                    } else if viewModel.request.status == .FINISHED {
                        Button {
                            viewModel.isShowingReview = true
                        } label: {
                            CMButton(title: viewModel.review == nil ? "Write review" : "Edit review", fullWidth: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.all, 10)
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 10)
            }
            .blur(radius: viewModel.isShowingCancelModal ? 20 : 0)
            .disabled(viewModel.isShowingCancelModal)
            
            if viewModel.isShowingCancelModal {
                TextFieldActionView(buttonText: BookingAction.cancel.actionText(),
                                    isShowingView: $viewModel.isShowingCancelModal) { message in
                    viewModel.handleCancelAction(message: message)
                }
                
                TextFieldActionView(buttonText: BookingAction.cancel.actionText(),
                                    isShowingView: $viewModel.isShowingCancelModal) { message in
                    viewModel.handleCancelAction(message: message)
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Booking with \(viewModel.host.firstName ?? "")")
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(profile: viewModel.host,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: false)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingReview) {
            WriteReviewView(myUserId: viewModel.myProfile.userId,
                            reviewing: viewModel.host,
                            topic: viewModel.topic,
                            request: viewModel.request,
                            existingReview: viewModel.review,
                            isShowingReview: $viewModel.isShowingReview)
        }
        .onAppear() {
            viewModel.fetchData()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return BookingStatusView(myProfile: MockData.mockProfile(),
                             request: MockData.mockRequest2(),
                             navigationPath: .constant([]))
}
