//
//  TopicDetailsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct TopicDetailsView: View {
    @StateObject var viewModel: TopicDetailsViewModel
    @Binding var navigationPath: [ScreenNames]
    
    init(topic: Topic, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: TopicDetailsViewModel(topic: topic))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 10) {
                    if let urlString = viewModel.topic.userProfile?.avatarUrl {
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
                        Text(viewModel.topic.userProfile?.fullName ?? "")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(viewModel.topic.userProfile?.jobTitle ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Text(viewModel.topic.userProfile?.company ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.all, 10)
                
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
                
                HStack {
                    Text(viewModel.topic.displayablePrice)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        CMChatButton()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 10)
                
                Divider()
                    .frame(height: 5)
                    .overlay(Color(.systemGray6))
                
                Button {
                    navigationPath.append(.selectTime(viewModel.topic, viewModel.topic.userProfile!))
                } label: {
                    CMButton(title: "Schedule a time")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 20)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 20)
            
        }
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            UserDetailsView(myProfile: UserManager.shared.profile!,
                            profile: viewModel.topic.userProfile!,
                            isShowingProfile: $viewModel.isShowingProfile,
                            loadTopics: false)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TopicDetailsView(topic: MockData.mockTopic(), navigationPath: .constant([]))
}
