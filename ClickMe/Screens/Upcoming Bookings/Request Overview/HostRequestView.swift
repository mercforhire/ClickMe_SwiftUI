//
//  HostRequestView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct HostRequestView: View {
    @StateObject var viewModel: HostRequestViewModel
    @Binding var navigationPath: [ScreenNames]
    
    init(request: Request, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: HostRequestViewModel(request: request))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 10) {
                        if let urlString = viewModel.booker.avatarUrl {
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
                            Text("\(viewModel.booker.firstName ?? "") \(viewModel.booker.lastName ?? "")")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(viewModel.booker.jobTitle ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Text(viewModel.booker.company ?? "")
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
                        HStack {
                            Text(receipt.displayablePrice)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text("minus platform fees (20%)")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 10)
                    }
                    
                    Divider()
                        .frame(height: 5)
                        .overlay(Color(.systemGray6))
                    
                    if let actionError = viewModel.actionError {
                        CMErrorLabel(actionError)
                            .padding(.horizontal, 10)
                    }
                    
                    if viewModel.request.status == .PENDING_APPROVAL {
                        Button {
                            viewModel.isShowingAcceptModal = true
                        } label: {
                            CMButton(title: "Accept", fullWidth: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.all, 10)
                        
                        Button {
                            viewModel.isShowingDeclineModal = true
                        } label: {
                            CMButton(title: "Reject", fullWidth: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.all, 10)
                    } else if viewModel.request.status == .APPROVED {
                        Button {
                            viewModel.handleStartAction()
                        } label: {
                            CMButton(title: "Start call", fullWidth: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.all, 10)
                        
                        Button {
                            viewModel.isShowingCancelModal = true
                        } label: {
                            CMButton(title: "Cancel", fullWidth: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.all, 10)
                    } else if viewModel.request.status == .FINISHED {
                        if let review = viewModel.review {
                            VStack(alignment: .center, spacing: 10) {
                                MyCosmosView(rating: .constant(review.rating),
                                             tintColor: .systemYellow)
                                
                                Text(review.comment)
                                    .font(.body)
                                    .fontWeight(.regular)
                                    .foregroundColor(.primary)
                            }
                            .padding(.all, 10)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 10)
            }
            .blur(radius: (viewModel.isShowingAcceptModal || viewModel.isShowingCancelModal || viewModel.isShowingDeclineModal) ? 20 : 0)
            .disabled((viewModel.isShowingAcceptModal || viewModel.isShowingCancelModal || viewModel.isShowingDeclineModal))
            
            if viewModel.isShowingAcceptModal {
                TextFieldActionView(buttonText: BookingAction.accept.actionText(),
                                    isShowingView: $viewModel.isShowingAcceptModal) { message in
                    viewModel.handleAcceptAction(message: message)
                }
                
            } else if viewModel.isShowingDeclineModal {
                TextFieldActionView(buttonText: BookingAction.decline.actionText(),
                                    isShowingView: $viewModel.isShowingDeclineModal) { message in
                    viewModel.handleDeclineAction(message: message)
                }
            } else if viewModel.isShowingCancelModal {
                TextFieldActionView(buttonText: BookingAction.cancel.actionText(),
                                    isShowingView: $viewModel.isShowingCancelModal) { message in
                    viewModel.handleCancelAction(message: message)
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Booking with \(viewModel.booker.firstName ?? "")")
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(profile: viewModel.booker,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: false)
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    return NavigationStack {
        HostRequestView(request: MockData.mockRequest3(),
                        navigationPath: .constant([]))
    }
}
