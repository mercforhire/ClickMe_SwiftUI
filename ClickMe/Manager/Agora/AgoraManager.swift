//
//  AgoraManager.swift
//  Docs-Examples
//
//  Created by Max Cobb on 03/04/2023.
//

import AgoraRtcKit
import SwiftUI
import AVFoundation

enum ConnectionState {
    case waiting
    case ready
    case disconnected
}

enum SpeakerState {
    case muted
    case ear
    case speaker
    
    func iconName() -> String {
        switch self {
        case .muted:
            return "speaker.slash.fill"
        case .ear:
            return "ear"
        case .speaker:
            return "speaker.wave.3.fill"
        }
    }
}

enum MicState {
    case muted
    case speaking
    
    func iconName() -> String {
        switch self {
        case .muted:
            return "mic.slash.fill"
        case .speaking:
            return "mic.fill"
        }
    }
}

@MainActor
final class AgoraManager: NSObject, ObservableObject {
    @Published var isPresentingCallScreen: Bool = false
    @Published var inInACall: Bool = false
    @Published var remoteConnectionState: ConnectionState?
    @Published var speakerState: SpeakerState?
    @Published var myMicState: MicState?
    @Published var remoteMicState: MicState?
    @Published var agoraError: String?
    
    private var callingUser: UserProfile?
    private var request: Request?
    private var topic: Topic?
    private var token: String?
    private var channelId: String?
    
    private var agoraKit: AgoraRtcEngineKit!
    private var audioProfile: AgoraAudioProfile = .default
    private var audioScenario: AgoraAudioScenario = .default
    
    static func checkForPermissions() async -> Bool {
        let hasPermissions = await self.avAuthorization(mediaType: .audio)
        return hasPermissions
    }
    
    static func avAuthorization(mediaType: AVMediaType) async -> Bool {
        let mediaAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch mediaAuthorizationStatus {
        case .denied, .restricted: return false
        case .authorized: return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default: return false
        }
    }
    
    func initializeAgora(appId: String) {
        guard agoraKit == nil else { return }
        
        // initialize Agora Engine
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
            
        agoraKit.setChannelProfile(.communication)
        agoraKit.setClientRole(.broadcaster)
        
        // disable video module
        agoraKit.disableVideo()
        
        // set audio profile/audio scenario
        agoraKit.setAudioProfile(.speechStandard)
        
        // Set audio route to speaker
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        // enable volume indicator
        agoraKit.enableAudioVolumeIndication(200, smooth: 3, reportVad: false)
        
        agoraKit.setEnableSpeakerphone(true)
    }
    
    func joinChannel(callingUser: UserProfile,
                     request: Request,
                     topic: Topic,
                     token: String,
                     completion: (() -> Void)? = nil) {
        self.callingUser = callingUser
        self.request = request
        self.topic = topic
        self.token = token
        self.channelId = request._id
        
        if inInACall {
            print("AgoraManager: can't join channel, already in a call.")
            return
        }
        
        // start joining channel
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. If app certificate is turned on at dashboard, token is needed
        // when joining channel. The channel name and uid used to calculate
        // the token has to match the ones used for channel join
        agoraKit.joinChannel(byToken: token, channelId: request._id, info: nil, uid: 0) { sid, uid, elapsed in
            print("AgoraManager: joinChannel: \(sid), \(uid), \(elapsed)")
            self.remoteConnectionState = .waiting
            self.inInACall = true
            self.speakerState = .speaker
            self.myMicState = .speaking
            self.remoteMicState = .speaking
            completion?()
        }
    }
    
    func mutedMic() {
        guard inInACall else { return }
        
        agoraKit.muteLocalAudioStream(true)
        myMicState = .muted
    }
    
    func unmutedMic() {
        guard inInACall else { return }
        
        agoraKit.muteLocalAudioStream(false)
        myMicState = .speaking
    }
    
    func mutedSpeaker() {
        guard inInACall else { return }
        
        agoraKit.adjustPlaybackSignalVolume(0)
        speakerState = .muted
    }
    
    func useEar() {
        guard inInACall else { return }
        
        agoraKit.setEnableSpeakerphone(false)
        agoraKit.adjustPlaybackSignalVolume(100)
        speakerState = .ear
    }
    
    func useSpeaker() {
        guard inInACall else { return }
        
        agoraKit.setEnableSpeakerphone(true)
        agoraKit.adjustPlaybackSignalVolume(100)
        speakerState = .speaker
    }
    
    func leaveChannel(completion: (() -> Void)? = nil) {
        guard inInACall else { return }
        
        agoraKit.leaveChannel { stats in
            print("AgoraManager leaveChannel:\(stats)")
            self.inInACall = false
            completion?()
        }
    }
    
    func resetValues() {
        inInACall = false
        callingUser = nil
        request = nil
        topic = nil
        token = nil
        channelId = nil
        remoteConnectionState = nil
        speakerState = nil
        myMicState = nil
        remoteMicState = nil
    }
}

// MARK: - Delegate Methods

extension AgoraManager: AgoraRtcEngineDelegate {
    /// callback when warning occured for agora sdk, warning can usually be ignored, still it's nice to check out
    /// what is happening
    /// Warning code description can be found at:
    /// en: https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraWarningCode.html
    /// cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraWarningCode.html
    /// @param warningCode warning code of the problem
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("AgoraManager warning: \(warningCode)")
    }
    
    /// callback when error occured for agora sdk, you are recommended to display the error descriptions on demand
    /// to let user know something wrong is happening
    /// Error code description can be found at:
    /// en: https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
    /// cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
    /// @param errorCode error code of the problem
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("AgoraManager rtcEngine error: \(errorCode)")
        
        if errorCode == AgoraErrorCode.tokenExpired {
            agoraError = "TOKEN_EXPIRED"
        } else if errorCode == AgoraErrorCode.invalidToken {
            agoraError = "INVALID_TOKEN"
        }
    }
    
    /// callback when the local user joins a specified channel.
    /// @param channel
    /// @param uid uid of local user
    /// @param elapsed time elapse since current sdk instance join the channel in ms
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("AgoraManager join \(channel) with uid \(uid) elapsed \(elapsed)ms")
    }
    
    /// callback when a remote user is joinning the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param elapsed time elapse since current sdk instance join the channel in ms
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("AgoraManager remote user join: \(uid) \(elapsed)ms")
        remoteConnectionState = .ready
    }
    
    /// callback when a remote user is leaving the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param reason reason why this user left, note this event may be triggered when the remote user
    /// become an audience in live broadcasting profile
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("AgoraManager remote user left: \(uid) reason \(reason)")
        remoteConnectionState = .disconnected
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        if uid != 0 {
            remoteMicState = muted ? .muted : .speaking
        }
        print("AgoraManager uid\(uid) muted \(muted ? "muted" : "unmuted")")
    }
}
