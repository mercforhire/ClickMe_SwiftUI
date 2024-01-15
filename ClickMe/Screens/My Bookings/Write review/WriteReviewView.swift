//
//  WriteReviewView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import SwiftUI

struct WriteReviewView: View {
    @Binding var isShowingReview: Bool
    @StateObject var viewModel: WriteReviewViewModel
    
    init(myUserId: String, reviewing: UserProfile, topic: Topic, request: Request, existingReview: Review? = nil, isShowingReview: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: WriteReviewViewModel(myUserId: myUserId, reviewing: reviewing, topic: topic, request: request, existingReview: existingReview))
        _isShowingReview = isShowingReview
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
                SpeakerAvatarView(user: viewModel.reviewing, micState: .constant(nil), connected: .constant(true))
                    .frame(width: 130, height: 180)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                
                Text("Rate your call")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                MyCosmosView(rating: $viewModel.rating)
                    .frame(height: 40)
                
                if !viewModel.writtenReview.isEmpty {
                    Text(viewModel.writtenReview)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .lineLimit(8)
                        .onTapGesture {
                            viewModel.isShowingCommentModal = true
                        }
                } else {
                    Button(action: {
                        viewModel.isShowingCommentModal = true
                    }, label: {
                        Text("Add a review")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    })
                }
                
                Spacer()
                
                if let reviewSubmittionError = viewModel.reviewSubmittionError {
                    CMErrorLabel(reviewSubmittionError)
                        .padding(.all, 5)
                        .background(Color.white.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                Button(action: {
                    viewModel.submitReview()
                }, label: {
                    Text("Submit")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 50,
                            alignment: .center
                        )
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
            .background(Color.accentColor)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    isShowingReview = false
                }, label: {
                    CMXButton()
                })
                .padding([.top, .trailing], 10)
            }
            .blur(radius: viewModel.isShowingCommentModal ? 20 : 0)
            .disabled(viewModel.isShowingCommentModal)
            
            if viewModel.isShowingCommentModal {
                TextFieldActionView(buttonText: "Save", 
                                    placeholder: "Please type a comment about your experience with \(viewModel.reviewing.firstName ?? "")",
                                    isShowingView: $viewModel.isShowingCommentModal,
                                    initialMessage: viewModel.writtenReview) { message in
                    viewModel.writtenReview = message
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .onChange(of: viewModel.reviewSubmitSuccess) { success in
            if success {
                NotificationCenter.default.post(name: Notifications.RefreshBookingRequest, object: nil, userInfo: ["request": viewModel.request])
                
                isShowingReview = false
            }
        }
    }
}

#Preview {
    WriteReviewView(myUserId: MockData.mockProfile().userId, reviewing: MockData.mockProfile2(), topic: MockData.mockTopic(), request: MockData.mockRequest(), isShowingReview: .constant(true))
}
