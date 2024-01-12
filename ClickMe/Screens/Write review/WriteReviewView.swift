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
    
    init(reviewing: UserProfile, topic: Topic, request: Request, isShowingReview: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: WriteReviewViewModel(reviewing: reviewing, topic: topic, request: request))
        _isShowingReview = isShowingReview
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            SpeakerAvatarView(user: viewModel.reviewing, micState: .constant(.muted), connected: .constant(true))
                .frame(width: 130, height: 180)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            Text("Rate your call")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            Spacer()
            
            MyCosmosView(rating: $viewModel.rating)
                .frame(height: 40)
            
            Button(action: {
                
            }, label: {
                CMButton(title: "Add a review")
            })
            
            Button(action: {
                
            }, label: {
                CMButton(title: "Submit")
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
    }
}

#Preview {
    WriteReviewView(reviewing: MockData.mockProfile2(), topic: MockData.mockTopic(), request: MockData.mockRequest(), isShowingReview: .constant(true))
}
