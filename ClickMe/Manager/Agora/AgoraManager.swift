//
//  AgoraManager.swift
//  Docs-Examples
//
//  Created by Max Cobb on 03/04/2023.
//

import AgoraRtcKit
import SwiftUI
import AVFoundation

/// ``AgoraManager`` is a class that provides an interface to the Agora RTC Engine Kit.
/// It conforms to the `ObservableObject` and `AgoraRtcEngineDelegate` protocols.
///
/// Use AgoraManager to set up and manage Agora RTC sessions, manage the client's role,
/// and control the client's connection to the Agora RTC server.
open class AgoraManager: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    /// The Agora App ID for the session.
    public let appId: String
    /// The client's role in the session.
    public var role: AgoraClientRole = .audience {
        didSet { agoraEngine.setClientRole(role) }
    }
    
    /// The set of all users in the channel.
    @Published public var allUsers: Set<UInt> = []
    
    @Published var label: String?
    
    /// Integer ID of the local user.
    @Published public var localUserId: UInt = 0
    
    // MARK: - Agora Engine Functions
    
    private var engine: AgoraRtcEngineKit?
    /// The Agora RTC Engine Kit for the session.
    public var agoraEngine: AgoraRtcEngineKit {
        if let engine { return engine }
        let engine = setupEngine()
        self.engine = engine
        return engine
    }
    
    static func checkForPermissions() async -> Bool {
        var hasPermissions = await self.avAuthorization(mediaType: .video)
        // Break out, because camera permissions have been denied or restricted.
        if !hasPermissions { return false }
        hasPermissions = await self.avAuthorization(mediaType: .audio)
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
    
    open func setupEngine() -> AgoraRtcEngineKit {
        let eng = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        eng.enableAudio()
        eng.setClientRole(role)
        return eng
    }
    
    /// Joins a channel, starting the connection to an RTC session.
    /// - Parameters:
    ///   - channel: Name of the channel to join.
    ///   - token: Token to join the channel, this can be nil for an weak security testing session.
    ///   - uid: User ID of the local user. This can be 0 to allow the engine to automatically assign an ID.
    ///   - mediaOptions: AgoraRtcChannelMediaOptions object for join settings
    /// - Returns: Error code, 0 = success, &lt; 0 = failure.
    @discardableResult
    open func joinChannel(
        _ channel: String, token: String? = nil, uid: UInt = 0,
        mediaOptions: AgoraRtcChannelMediaOptions? = nil
    ) async -> Int32 {
        if await !AgoraManager.checkForPermissions() {
            await self.updateLabel(key: "invalid-permissions")
            return -3
        }
        
        if let mediaOptions {
            return self.agoraEngine.joinChannel(
                byToken: token, channelId: channel,
                uid: uid, mediaOptions: mediaOptions
            )
        }
        return self.agoraEngine.joinChannel(
            byToken: token, channelId: channel,
            info: nil, uid: uid
        )
    }
    
    /// Joins a video call, establishing a connection for video communication.
    /// - Parameters:
    ///   - channel: Name of the channel to join.
    ///   - token: Token to join the channel, this can be nil for a weak security testing session.
    ///   - uid: User ID of the local user. This can be 0 to allow the engine to automatically assign an ID.
    /// - Returns: Error code, 0 = success, &lt; 0 = failure.
    @discardableResult
    func joinVideoCall(
        _ channel: String, token: String? = nil, uid: UInt = 0
    ) async -> Int32 {
        /// See ``AgoraManager/checkForPermissions()``, or Apple's docs for details of this method.
        if await !AgoraManager.checkForPermissions() {
            await self.updateLabel(key: "invalid-permissions")
            return -3
        }
        
        let opt = AgoraRtcChannelMediaOptions()
        opt.channelProfile = .communication
        
        return self.agoraEngine.joinChannel(
            byToken: token, channelId: channel,
            uid: uid, mediaOptions: opt
        )
    }
    
    /// Joins a voice call, establishing a connection for audio communication.
    /// - Parameters:
    ///   - channel: Name of the channel to join.
    ///   - token: Token to join the channel, this can be nil for a weak security testing session.
    ///   - uid: User ID of the local user. This can be 0 to allow the engine to automatically assign an ID.
    /// - Returns: Error code, 0 = success, &lt; 0 = failure.
    @discardableResult
    func joinVoiceCall(_ channel: String, token: String? = nil, uid: UInt = 0) async -> Int32 {
        /// See ``AgoraManager/checkForPermissions()``, or Apple's docs for details of this method.
        if await !AgoraManager.checkForPermissions() {
            await self.updateLabel(key: "invalid-permissions")
            return -3
        }
        
        let opt = AgoraRtcChannelMediaOptions()
        opt.channelProfile = .communication
        
        return self.agoraEngine.joinChannel(
            byToken: token, channelId: channel,
            uid: uid, mediaOptions: opt
        )
    }
    
    /// Joins a broadcast stream, enabling broadcasting or audience mode.
    /// - Parameters:
    ///   - channel: Name of the channel to join.
    ///   - token: Token to join the channel, this can be nil for a weak security testing session.
    ///   - uid: User ID of the local user. This can be 0 to allow the engine to automatically assign an ID.
    ///   - isBroadcaster: Flag to indicate if the user is joining as a broadcaster (true) or audience (false).
    ///                    Defaults to true.
    /// - Returns: Error code, 0 = success, &lt; 0 = failure.
    @discardableResult
    func joinBroadcastStream(_ channel: String, token: String? = nil, uid: UInt = 0, isBroadcaster: Bool = true) async -> Int32 {
        /// See ``AgoraManager/checkForPermissions()``, or Apple's docs for details of this method.
        if isBroadcaster, await !AgoraManager.checkForPermissions() {
            await self.updateLabel(key: "invalid-permissions")
            return -3
        }
        
        let opt = AgoraRtcChannelMediaOptions()
        opt.channelProfile = .liveBroadcasting
        opt.clientRoleType = isBroadcaster ? .broadcaster : .audience
        opt.audienceLatencyLevel = isBroadcaster ? .ultraLowLatency : .lowLatency
        
        return self.agoraEngine.joinChannel(
            byToken: token, channelId: channel,
            uid: uid, mediaOptions: opt
        )
    }
    
    /// This method is used by this app specifically. If there is a tokenURL,
    /// it will attempt to retrieve a token from there.
    /// Otherwise it will simply apply the provided token in config.json or nil.
    ///
    /// - Parameters:
    ///   - channel: Name of the channel to join.
    ///   - uid: User ID of the local user. This can be 0 to allow the engine to automatically assign an ID.
    /// - Returns: Error code, 0 = success, &lt; 0 = failure.
    @discardableResult
    internal func joinChannel(_ rtcToken: String, channel: String, uid: UInt = 0, mediaOptions: AgoraRtcChannelMediaOptions? = nil) async -> Int32 {
        let userId = uid
        var token = rtcToken
        return await self.joinChannel(channel, token: token, uid: uid, mediaOptions: mediaOptions)
    }
    
    /// Leaves the channel and stops the preview for the session.
    ///
    /// - Parameter leaveChannelBlock: An optional closure that will be called when the client leaves the channel.
    ///      The closure takes an `AgoraChannelStats` object as its parameter.
    ///
    ///
    /// This method also empties all entries in ``allUsers``,
    @discardableResult
    open func leaveChannel(leaveChannelBlock: ((AgoraChannelStats) -> Void)? = nil, destroyInstance: Bool = true) -> Int32 {
        let leaveErr = self.agoraEngine.leaveChannel(leaveChannelBlock)
        self.agoraEngine.stopPreview()
        defer { if destroyInstance { AgoraRtcEngineKit.destroy() } }
        self.allUsers.removeAll()
        return leaveErr
    }
    
    // MARK: - Setup
    
    /// Initializes a new instance of `AgoraManager` with the specified app ID and client role.
    ///
    /// - Parameters:
    ///   - appId: The Agora App ID for the session.
    ///   - role: The client's role in the session. The default value is `.audience`.
    public init(appId: String, role: AgoraClientRole = .audience) {
        self.appId = appId
        self.role = role
    }
    
    @MainActor
    func updateLabel(to message: String) {
        self.label = message
    }
    
    @MainActor
    func updateLabel(key: String, comment: String = "") {
        self.label = NSLocalizedString(key, comment: comment)
    }
}

// MARK: - Delegate Methods

extension AgoraManager: AgoraRtcEngineDelegate {
    /// The delegate is telling us that the local user has successfully joined the channel.
    /// - Parameters:
    ///    - engine: The Agora RTC engine kit object.
    ///    - channel: The channel name.
    ///    - uid: The ID of the user joining the channel.
    ///    - elapsed: The time elapsed (ms) from the user calling `joinChannel` until this method is called.
    ///
    /// If the client's role is `.broadcaster`, this method also adds the broadcaster's
    /// userId (``localUserId``) to the ``allUsers`` set.
    open func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        self.localUserId = uid
        if self.role == .broadcaster {
            self.allUsers.insert(uid)
        }
    }
    
    /// The delegate is telling us that a remote user has joined the channel.
    ///
    /// - Parameters:
    /// - engine: The Agora RTC engine kit object.
    /// - uid: The ID of the user joining the channel.
    /// - elapsed: The time elapsed (ms) from the user calling `joinChannel` until this method is called.
    ///
    /// This method adds the remote user to the `allUsers` set.
    open func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        self.allUsers.insert(uid)
    }
    
    /// The delegate is telling us that a remote user has left the channel.
    ///
    /// - Parameters:
    ///     - engine: The Agora RTC engine kit object.
    ///     - uid: The ID of the user who left the channel.
    ///     - reason: The reason why the user left the channel.
    ///
    /// This method removes the remote user from the `allUsers` set.
    open func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        self.allUsers.remove(uid)
    }
}
