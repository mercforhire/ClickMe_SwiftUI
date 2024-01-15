//
//  UserDetailsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import SwiftUI

struct UserDetailsView: View {
    @Binding var isShowingProfile: Bool
    @StateObject private var viewModel: UserDetailsViewModel
    let loadTopics: Bool
    
    private let screenWidth = UIScreen.main.bounds.size.width
    
    init(myProfile: UserProfile, profile: UserProfile, isShowingProfile: Binding<Bool>, loadTopics: Bool) {
        _viewModel = StateObject(wrappedValue: UserDetailsViewModel(myProfile: myProfile, profile: profile))
        self._isShowingProfile = isShowingProfile
        self.loadTopics = loadTopics
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 5) {
                TabView() {
                    ForEach(viewModel.profile.userPhotos ?? []) { photo in
                        AsyncImage(url: URL(string: photo.url)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        } placeholder: {
                            LoadingView()
                        }
                    }
                }
                .frame(width: screenWidth, height: screenWidth * 1.2)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .overlay(alignment: .bottomTrailing) {
                    if !viewModel.lookingAtMySelf {
                        VStack {
                            Button {
                                viewModel.handleFollowButton()
                            } label: {
                                CMFollowButton(following: viewModel.following)
                            }
                            Button {
                                isShowingProfile = false
                                viewModel.handleChatButton()
                            } label: {
                                CMChatButton()
                            }
                        }
                        .padding([.bottom, .trailing], screenWidth / 25)
                    }
                }
                
                Text("\(viewModel.profile.firstName ?? "") \(viewModel.profile.lastName ?? "")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                Text("ID: \(viewModel.profile.screenId)")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                
                HStack {
                    Image(viewModel.profile.field?.imageName() ?? Field.other.imageName(), bundle: nil)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                    Text("\(viewModel.profile.jobTitle ?? "") at \(viewModel.profile.company ?? "")")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .lineLimit(5)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                
                HStack(alignment: .center, spacing: 20) {
                    VStack {
                        Text("\(viewModel.profile.numberOfFollowers ?? 0)")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Text("Followers")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(Color(.systemGray))
                    }
                    VStack {
                        Text(viewModel.ratings != nil ? "\(viewModel.ratings!, specifier: "%.1f")" : "--")
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
                
                Text("\(viewModel.profile.city ?? ""), \(viewModel.profile.state ?? ""), \(viewModel.profile.country?.text() ?? "")")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                
                Text(viewModel.profile.degree ?? "")
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
                
                Text(viewModel.profile.aboutMe ?? "")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                
                if !viewModel.topics.isEmpty {
                    Text("My topics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    
                    ForEach(viewModel.topics) { topic in
                        TopicView(topic: topic, hideHost: true)
                            .frame(height: 300)
                            .onTapGesture {
                                isShowingProfile = false
                                viewModel.handleOpenTopic(topic: topic)
                            }
                        Divider()
                    }
                }
            }
        }
        .background(Color(.systemGray6))
        .onAppear() {
            if loadTopics {
                viewModel.getUserTopics()
            }
            viewModel.getFollowStatus()
            viewModel.getRatings()
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
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return UserDetailsView(myProfile: MockData.mockProfile(), profile: MockData.mockProfile2(), isShowingProfile: .constant(true), loadTopics: true)
}
