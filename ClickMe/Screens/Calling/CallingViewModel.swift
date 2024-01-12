//
//  CallingViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

enum MeetingState {
    case connecting
    case ongoing
    case almostOver
    case ended
}

enum ConnectionState {
    case waiting
    case ready
    case disconnected
}

enum SpeakerState {
    case muted
    case ear
    case speaker
}

enum MicState {
    case muted
    case speaking
}

@MainActor
final class CallingViewModel: ObservableObject {
    var myProfile: UserProfile
    var talkingTo: UserProfile
    var topic: Topic
    var request: Request
    var token: String
    
    @Published var meetingState: MeetingState = .connecting
    @Published var myMicState: MicState = .speaking
    @Published var talkingToMicState: MicState = .speaking
    
    var endTime: String {
        return  DateUtil.convert(input: request.endTime, outputFormat: .format8)!
    }
    
    init(myProfile: UserProfile, talkingTo: UserProfile, topic: Topic, request: Request, token: String) {
        self.myProfile = myProfile
        self.talkingTo = talkingTo
        self.topic = topic
        self.request = request
        self.token = token
    }
    
    
}
