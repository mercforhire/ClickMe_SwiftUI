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

final class AgoraManager: NSObject, ObservableObject {
    @Published var isPresentingCallScreen: Bool = false
    @Published var inInACall: Bool = false
    @Published var myConnectionState: ConnectionState = .waiting
    @Published var remoteConnectionState: ConnectionState = .waiting
    @Published var mySpeakerState: SpeakerState?
    @Published var myMicState: MicState?
    @Published var remoteMicState: MicState?
    @Published var agoraError: String?
    
    @Published var initializing: Bool = false
    @Published var joiningChannel: Bool = false
    
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
    
    func initializeAgora(appId: String) async {
        guard agoraKit == nil else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.initializing = true
        }
       
        return await withCheckedContinuation { [weak self] continuation in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self else { return }
                
                self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
                self.agoraKit.setChannelProfile(.communication)
                self.agoraKit.setClientRole(.broadcaster)
                // disable video module
                self.agoraKit.disableVideo()
                // set audio profile/audio scenario
                self.agoraKit.setAudioProfile(.speechStandard)
                // Set audio route to speaker
                self.agoraKit.setDefaultAudioRouteToSpeakerphone(true)
                // enable volume indicator
                self.agoraKit.enableAudioVolumeIndication(200, smooth: 3, reportVad: false)
                self.agoraKit.setEnableSpeakerphone(true)
                
                print("AgoraManager: agoraKit initialized.")
                DispatchQueue.main.async {
                    self.initializing = false
                    continuation.resume()
                }
            }
        }
    }
    
    func joinChannel(callingUser: UserProfile,
                     request: Request,
                     topic: Topic,
                     token: String) async -> Void {
        guard agoraKit != nil else {
            print("AgoraManager: agoraKit is not initialized!")
            return
        }
        
        if inInACall {
            print("AgoraManager: can't join channel, already in a call.")
            return
        }
        
        self.callingUser = callingUser
        self.request = request
        self.topic = topic
        self.token = token
        self.channelId = request._id
        
        DispatchQueue.main.async { [weak self] in
            self?.joiningChannel = true
        }
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self else { return }
                
                // start joining channel
                // 1. Users can only see each other after they join the
                // same channel successfully using the same app id.
                // 2. If app certificate is turned on at dashboard, token is needed
                // when joining channel. The channel name and uid used to calculate
                // the token has to match the ones used for channel join
                self.agoraKit.joinChannel(byToken: token, channelId: request._id, info: nil, uid: 0) { sid, uid, elapsed in
                    DispatchQueue.main.async {
                        print("AgoraManager: joinChannel: \(sid), \(uid), \(elapsed)")
                        self.inInACall = true
                        self.myConnectionState = .ready
                        self.mySpeakerState = .speaker
                        self.myMicState = .speaking
                        self.joiningChannel = false
                        continuation.resume()
                    }
                }
                
            }
        }
    }
    
    func sendJoinSessionAction() async {
        guard let request else { return }
        
        _ = try? await ClickAPI.shared.sessionAction(requestId: request._id, action: "JOIN")
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
        mySpeakerState = .muted
    }
    
    func useEar() {
        guard inInACall else { return }
        
        agoraKit.setEnableSpeakerphone(false)
        agoraKit.adjustPlaybackSignalVolume(100)
        mySpeakerState = .ear
    }
    
    func useSpeaker() {
        guard inInACall else { return }
        
        agoraKit.setEnableSpeakerphone(true)
        agoraKit.adjustPlaybackSignalVolume(100)
        mySpeakerState = .speaker
    }
    
    func leaveChannel() async -> Void {
        guard inInACall else { return }
        
        return await withCheckedContinuation { continuation in
            self.agoraKit.leaveChannel { stats in
                DispatchQueue.main.async {
                    print("AgoraManager leaveChannel:\(stats)")
                    self.inInACall = false
                    continuation.resume()
                }
            }
        }
    }
    
    func resetValues() {
        inInACall = false
        callingUser = nil
        request = nil
        topic = nil
        token = nil
        channelId = nil
        myConnectionState = .waiting
        remoteConnectionState = .waiting
        mySpeakerState = nil
        myMicState = nil
        remoteMicState = nil
        agoraError = nil
    }
        
    func destroyAgoraEngine() {
        AgoraRtcEngineKit.destroy()
        print("AgoraManager: agoraKit destroyed.")
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
        myConnectionState = .ready
    }
    
    /// callback when a remote user is joinning the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param elapsed time elapse since current sdk instance join the channel in ms
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("AgoraManager remote user join: \(uid) \(elapsed)ms")
        remoteConnectionState = .ready
    }
    
    /**
     * Occurs when a remote user or host goes offline.
     *
     * There are two reasons for a user to go offline:
     * - Leave the channel: When the user leaves the channel, the user sends a
     * goodbye message. When this message is received, the SDK determines that the
     * user leaves the channel.
     * - Drop offline: When no data packet of the user is received for a certain
     * period of time, the SDK assumes that the user drops offline. A poor network
     * connection may lead to false detection, so we recommend using
     * the RTM SDK for reliable offline detection.
     *
     * @param engine The AgoraRtcEngineKit object.
     * @param uid The ID of the user who goes offline.
     * @param reason The reason why the user goes offline: #AgoraUserOfflineReason.
     */
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("AgoraManager remote user left: \(uid) reason \(reason)")
        if uid == 0 {
            myConnectionState = .disconnected
        } else {
            remoteConnectionState = .disconnected
        }
    }
    
    /**
     * Occurs when the local user rejoins a channel.
     *
     * If the client loses connection with the server because of network problems,
     * the SDK automatically attempts to reconnect and then triggers this callback
     * upon reconnection, indicating that the user rejoins the channel with the
     * assigned channel ID and user ID.
     *
     * @param engine  The AgoraRtcEngineKit object.
     * @param channel The channel name.
     * @param uid     The user ID.
     * @param elapsed Time elapsed (ms) from the local user calling `joinChannelByToken` until this event occurs.
     */
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        myConnectionState = .ready
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        if uid != 0 {
            remoteMicState = muted ? .muted : .speaking
        }
        print("AgoraManager uid\(uid) muted \(muted ? "muted" : "unmuted")")
    }
}
