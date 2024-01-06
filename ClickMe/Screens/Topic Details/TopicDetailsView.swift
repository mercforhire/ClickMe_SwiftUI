//
//  TopicDetailsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct TopicDetailsView: View {
    let topic: Topic
    @Binding var isShowingTopic: Bool
    @StateObject var viewModel = TopicDetailsViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                if let profile = topic.userProfile {
                    HStack(alignment: .center, spacing: 10) {
                        if let urlString = profile.userPhotos?.first?.thumbnail {
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
                                print("avatar pressed")
                                viewModel.isShowingProfile = true
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(profile.firstName ?? "") \(profile.lastName ?? "")")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Text(profile.jobTitle ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Text(profile.company ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.all, 10)
                    
                    Divider()
                        .frame(height: 5)
                        .overlay(Color(.systemGray6))
                    
                    HStack {
                        Image(topic.mood.imageName(), bundle: nil)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                        
                        Text("\(topic.mood.text())")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .padding(.all, 10)
                    
                    Text(topic.title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    
                    Text(topic.description)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    
                    HStack {
                        Text(topic.displayablePrice)
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
                        
                    } label: {
                        CMButton(title: "Schedule a time")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
                } else {
                    LoadingView()
                }
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 20)
            
        }
        .background(Color(.systemGray6))
        .onAppear() {
            viewModel.topic = topic
        }
        .fullScreenCover(isPresented: $viewModel.isShowingProfile) {
            if let topicHost = viewModel.topic?.userProfile {
                UserDetailsView(profile: topicHost, 
                                isShowingProfile: $viewModel.isShowingProfile,
                                loadTopics: false)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                isShowingTopic = false
            }, label: {
                CMXButton()
            })
            .padding(.top, 10)
            .padding(.trailing, 30)
        }
    }
}

#Preview {
    TopicDetailsView(topic: Topic.mockTopic(), isShowingTopic: .constant(true))
}
