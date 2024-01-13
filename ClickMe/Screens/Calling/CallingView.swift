//
//  CallingView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import SwiftUI

struct CallingView: View {
    @Binding var isShowingCallScreen: Bool
    @StateObject var viewModel: CallingViewModel
    
    init(myProfile: UserProfile, talkingTo: UserProfile, topic: Topic, request: Request, token: String, isShowingCallScreen: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: CallingViewModel(myProfile: myProfile, talkingTo: talkingTo, topic: topic, request: request, token: token))
        _isShowingCallScreen = isShowingCallScreen
    }
    
    init(viewModel: CallingViewModel, isShowingCallScreen: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isShowingCallScreen = isShowingCallScreen
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            HStack(alignment: .top) {
                SpeakerAvatarView(user: viewModel.myProfile, 
                                  micState: .constant(nil),
                                  connected: .constant(true))
                    .frame(width: 130, height: 180)
                SpeakerAvatarView(user: viewModel.talkingTo, 
                                  micState: $viewModel.talkingToMicState,
                                  connected: $viewModel.otherPersonIsConnected)
                    .frame(width: 130, height: 180)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
            Text(viewModel.topic.title)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(2)
                .padding(.horizontal, 20)
            
            Text("Meeting end at \(viewModel.meetingEndTime)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            Spacer()
            
            if viewModel.meetingState == .almostOver {
                Text("You have 5 minutes left in this booking")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.all, 15)
                    .background(Color.white.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } else if viewModel.meetingState == .ended {
                Text("Meeting ended")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.all, 15)
                    .background(Color.white.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
            HStack(spacing: 30) {
                Button(action: {
                    
                }, label: {
                    CMRoundButton(iconName: viewModel.micIconName)
                })
                
                Button(action: {
                    
                }, label: {
                    CMRoundButton(iconName: viewModel.speakerIconName)
                })
            }
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                HangUpButton()
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
                isShowingCallScreen = false
            }, label: {
                CMMinimizeButton()
            })
            .padding([.top, .trailing], 10)
        }
    }
}

#Preview {
    let vm = CallingViewModel(myProfile: MockData.mockProfile(), talkingTo: MockData.mockProfile2(), topic: MockData
        .mockTopic(), request: MockData.mockRequest(), token: "abc")
    vm.meetingState = .almostOver
    return CallingView(viewModel: vm, isShowingCallScreen: .constant(true))
}

struct SpeakerAvatarView: View {
    var user: UserProfile
    @Binding var micState: MicState?
    @Binding var connected: Bool
    
    var micStateIconName: String {
        switch micState {
        case .muted:
            return "mic.slash.fill"
        case .speaking:
            return "mic.fill"
        default:
            return ""
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 5) {
                if let urlString = user.avatarThumbnailUrl {
                    AsyncImage(url: URL(string: urlString)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image("male-l", bundle: nil)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5)
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .clipped()
                } else {
                    Image("male-l", bundle: nil)
                        .resizable()
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .clipped()
                }
                
                Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("\(user.jobTitle ?? "")")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .overlay(alignment: .topTrailing) {
                if let micState = micState {
                    Image(systemName: micStateIconName)
                        .imageScale(.medium)
                        .foregroundColor(.white)
                }
            }
            
            if !connected {
                Text("Waiting")
                    .font(.body)
                    .fontWeight(.medium)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

struct HangUpButton: View {
    var body: some View {
        HStack(alignment: .center) {
            Label("Leave Meeting", systemImage: "phone.down.fill")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(height: 50)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
