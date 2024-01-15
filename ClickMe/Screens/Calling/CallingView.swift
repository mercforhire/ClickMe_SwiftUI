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
    @EnvironmentObject var agora: AgoraManager
    
    init(myProfile: UserProfile,
         talkingTo: UserProfile,
         topic: Topic,
         request: Request,
         isShowingCallScreen: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: CallingViewModel(myProfile: myProfile, talkingTo: talkingTo, topic: topic, request: request))
        _isShowingCallScreen = isShowingCallScreen
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            HStack(alignment: .top) {
                SpeakerAvatarView(user: viewModel.myProfile, 
                                  micState: $agora.myMicState,
                                  state: .constant(ConnectionState.ready))
                    .frame(width: 130, height: 180)
                SpeakerAvatarView(user: viewModel.talkingTo, 
                                  micState: $agora.remoteMicState,
                                  state: $agora.remoteConnectionState)
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
                Text("You have \(viewModel.minutesLeft) minutes left in this booking")
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
            
            if agora.inInACall {
                HStack(spacing: 30) {
                    Button(action: {
                        
                    }, label: {
                        CMRoundButton(iconName: agora.myMicState?.iconName() ?? "")
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        CMRoundButton(iconName: agora.mySpeakerState?.iconName() ?? "")
                    })
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await agora.leaveChannel()
                    }
                }, label: {
                    HangUpButton()
                })
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            } else {
                Spacer()
            }
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
    UserManager.shared.set(user: MockData.mockUser(), profile: MockData.mockProfile())
    return CallingView(myProfile: MockData.mockProfile(),
                       talkingTo: MockData.mockProfile2(),
                       topic: MockData.mockTopic(),
                       request: MockData.mockRequest(),
                       isShowingCallScreen: .constant(true))
    .environmentObject({() -> AgoraManager in
        let agora = AgoraManager()
        return agora
    }())
}

struct SpeakerAvatarView: View {
    var user: UserProfile
    @Binding var micState: MicState?
    @Binding var state: ConnectionState
    
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
                    Image(systemName: micState.iconName())
                        .imageScale(.medium)
                        .foregroundColor(.white)
                }
            }
            
            if state == .waiting {
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
