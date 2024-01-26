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
    
    @Published var meetingState: MeetingState = .connecting
    
    var meetingEndTime: String {
        return DateUtil.convert(input: request.endTime, outputFormat: .format8)!
    }
    var minutesLeft: Int {
        guard Date() < request.endTime else { return 0 }
        
        let difference = Calendar.current.dateComponents([.minute], from: Date(), to: request.endTime).minute
        return difference ?? 0
    }
    private var refreshTimer: Timer?
    
    init(myProfile: UserProfile, talkingTo: UserProfile, topic: Topic, request: Request) {
        self.myProfile = myProfile
        self.talkingTo = talkingTo
        self.topic = topic
        self.request = request
    }
    
    func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 5,
                                            target: self,
                                            selector: #selector(timerFunction),
                                            userInfo: nil,
                                            repeats: true)
        refreshTimer?.fire()
    }
    
    @objc func timerFunction() {
        if Date() >= request.endTime {
            meetingState = .ended
        } else if Date() > request.endTime.getPastOrFutureDate(minute: -5) {
            meetingState = .almostOver
        } else {
            meetingState = .ongoing
        }
    }
    
    func stopRefreshTime() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    func sendLeaveSessionAction() async {
        try? await ClickAPI.shared.sessionAction(requestId: request._id, action: "LEAVE")
    }
}
