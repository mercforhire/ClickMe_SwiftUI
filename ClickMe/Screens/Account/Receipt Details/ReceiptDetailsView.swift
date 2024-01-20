//
//  ReceiptDetailsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-19.
//

import SwiftUI

struct ReceiptDetailsView: View {
    @StateObject var viewModel: ReceiptDetailsViewModel
    
    init(myProfile: UserProfile, receipt: Receipt) {
        _viewModel = StateObject(wrappedValue: ReceiptDetailsViewModel(myProfile: myProfile, receipt: receipt))
    }
    
    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    if let urlString = viewModel.bookingUser.avatarUrl {
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
                        .onTapGesture {
                            viewModel.isShowingProfile = true
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.bookingUser.fullName)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(viewModel.bookingUser.jobTitle ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Text(viewModel.bookingUser.company ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                
                Text(viewModel.topic.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(viewModel.topic.displayablePrice)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            Section("Booking details") {
                VStack(alignment: .leading) {
                    Text("Time")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
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
                    
                    Text(viewModel.request._id)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            
            Section("Guest paid") {
                HStack(alignment: .center, spacing: 10) {
                    Text("Total")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.receipt.amountDisplayable)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            Section("Host payout") {
                HStack(alignment: .center, spacing: 10) {
                    Text("Platform fee")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.receipt.commissionDisplayable)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                HStack(alignment: .center, spacing: 10) {
                    Text("Paid out")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.receipt.amountPaidOutDisplayable)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                HStack(alignment: .center, spacing: 10) {
                    Text("Paid out date")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.receipt.statusChangeDateDisplayable)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(myProfile: viewModel.myProfile,
                            profile: viewModel.bookingUser,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: false)
        }
    }
}

#Preview {
    ReceiptDetailsView(myProfile: MockData.mockProfile2(), receipt: MockData.mockReceipt())
}
