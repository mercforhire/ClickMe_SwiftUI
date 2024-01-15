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

@MainActor
final class CallingViewModel: ObservableObject {
    var myProfile: UserProfile
    var talkingTo: UserProfile
    var topic: Topic
    var request: Request
    var token: String
    
    @Published var meetingState: MeetingState = .connecting
    @Published var micState: MicState = .speaking
    @Published var speakerState: SpeakerState = .speaker
    @Published var talkingToMicState: MicState?
    @Published var otherPersonIsConnected: Bool = false
    
    var meetingEndTime: String {
        return DateUtil.convert(input: request.endTime, outputFormat: .format8)!
    }
    
    var micIconName: String {
        switch micState {
        case .muted:
            return "mic.slash.fill"
        case .speaking:
            return "mic.fill"
        }
    }
    
    var speakerIconName: String {
        switch speakerState {
        case .muted:
            return "speaker.slash.fill"
        case .ear:
            return "ear"
        case .speaker:
            return "speaker.wave.3.fill"
        }
    }
    
    init(myProfile: UserProfile, talkingTo: UserProfile, topic: Topic, request: Request, token: String) {
        self.myProfile = myProfile
        self.talkingTo = talkingTo
        self.topic = topic
        self.request = request
        self.token = token
    }
    
}
