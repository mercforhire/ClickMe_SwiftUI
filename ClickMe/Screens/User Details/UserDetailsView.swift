//
//  UserDetailsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct UserDetailsView: View {
    let profile: UserProfile
    @Binding var isShowingProfile: Bool
    
    @StateObject var viewModel = UserDetailsViewModel()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        ScrollView(.vertical) {
            if let profile = viewModel.profile {
                VStack(alignment: .leading, spacing: 5) {
                    TabView(selection: $viewModel.tabSelection) {
                        ForEach(profile.userPhotos ?? []) { photo in
                            AsyncImage(url: URL(string: photo.url)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.accentColor
                            }
                            .clipped()
                        }
                    }
                    .frame(width: screenWidth, height: screenWidth * 1.2)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    // https://stackoverflow.com/questions/61827496/swiftui-how-to-animate-a-tabview-selection
                    .animation(.easeOut(duration: 0.2), value: viewModel.tabSelection)
                    .overlay(alignment: .bottomTrailing) {
                        VStack {
                            Button {
                                viewModel.handleFollowButton()
                            } label: {
                                CMFollowButton(following: viewModel.following)
                            }
                            Button {
                                
                            } label: {
                                CMChatButton()
                            }
                        }
                        .padding([.bottom, .trailing], screenWidth / 25)
                    }
                    
                    Text("\(profile.firstName ?? "") \(profile.lastName ?? "")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    Text("ID: \(profile.screenId)")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Image(profile.field?.imageName() ?? Field.other.imageName(), bundle: nil)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                        Text("\(profile.jobTitle ?? "") at \(profile.company ?? "")")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .lineLimit(5)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    
                    HStack(alignment: .center, spacing: 20) {
                        VStack {
                            Text("\(profile.numberOfFollowers ?? 0)")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            Text("Followers")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(Color(.systemGray))
                        }
                        VStack {
                            Text("\(4.5, specifier: "%.1f")")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            Text("Rating")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    
                    Text("Basic info")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    
                    Text("\(profile.city ?? ""), \(profile.state ?? ""), \(profile.country?.text() ?? "")")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    Text(profile.degree ?? "")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    Text("About me")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    
                    Text(profile.aboutMe ?? "")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    if !viewModel.topics.isEmpty {
                        Text("My topics")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.topics) { topic in
                                    TopicView(topic: topic, width: screenWidth * 0.6, height: 170)
                                        .padding(.leading, 20)
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemGray6))
        .onAppear() {
            viewModel.profile = profile
            viewModel.getUserTopics()
            viewModel.getFollowStatus()
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                isShowingProfile = false
            }, label: {
                CMXButton()
            })
            .padding([.top, .trailing], 10)
        }
    }
}

#Preview {
    UserDetailsView(profile: UserProfile.mockProfile(), isShowingProfile: .constant(true))
}
