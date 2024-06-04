import SwiftUI
import LiveKit
import WebRTC
import Foundation
import Promises

public protocol ParticipantPermissionUpdateDelegates {
    func participantPermissionDidUpdate(participantName: String, permissionAllow: Bool)
    func localParticipantChangeMuteStatus(pIdentity: String, status: Bool, trackType: TrackPublicationType)
    func remoteParticipantChangeMuteStatus(pIdentity: String, status: Bool, trackType: TrackPublicationType)
    func remoteParticipantJoinedOrLeave(participant: ParticipantView, trackType: ParticipantJoinType)
    func sepakingParticioant(pIdentity: String, status: Bool)
}

extension ParticipantPermissionUpdateDelegates {
    
    func remoteParticipantChangeMuteStatus(pIdentity: String, status: Bool) {
    }
}


public enum ParticipantJoinType {
    case joined
    case leave
    case none
}


public enum TrackPublicationType {
    case audio
    case video
    case screenShare
    case none
}

// This class contains the logic to control behavior of the whole app.
public class RoomContext: ObservableObject {
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    
    public var meetingDisconnetCallback: ((String) -> Void)?
    private let store: ValueStore<Preferences>
    
    // Used to show connection error dialog
    // private var didClose: Bool = false
    @Published var shouldShowDisconnectReason: Bool = false
    public var latestError: DisconnectReason?
    public let room = Room()
    public var roomView: RoomView?

    @Published var url: String = "" {
        didSet { store.value.url = url }
    }
    
    @Published var token: String = "" {
        didSet { store.value.token = token }
    }
    
    @Published var e2eeKey: String = "" {
        didSet { store.value.e2eeKey = e2eeKey }
    }
    
    @Published var e2ee: Bool = false {
        didSet { store.value.e2ee = e2ee }
    }
    
    // RoomOptions
    @Published var simulcast: Bool = true {
        didSet { store.value.simulcast = simulcast }
    }
    
    @Published var adaptiveStream: Bool = false {
        didSet { store.value.adaptiveStream = adaptiveStream }
    }
    
    @Published var dynacast: Bool = false {
        didSet { store.value.dynacast = dynacast }
    }
    
    @Published var reportStats: Bool = false {
        didSet { store.value.reportStats = reportStats }
    }
    
    // ConnectOptions
    @Published var autoSubscribe: Bool = true {
        didSet { store.value.autoSubscribe = autoSubscribe}
    }
    
    @Published var publish: Bool = false {
        didSet { store.value.publishMode = publish }
    }
    
    @Published var focusParticipant: Participant?
    @Published var showMessagesView: Bool = false
    @Published var messages: [ExampleRoomMessageNew] = []
    @Published var textFieldString: String = ""
    @Published var updateParticipantGrid: Bool = false
    @Published var participantsList = [ParticipantModel]()
    
    public var getMessageCallback: ((ExampleRoomMessageNew) -> Void)?
    public var recordingStatus: ((Bool) -> Void)?
    public var transcriptionStatus: ((Bool) -> Void)?
    public var muteMicrophone:((Bool) -> Void)?
    public var sendWaitingRequest:((RemoteParticipant) -> Void)? // it will send wating room request
    @Published public var updateWaitingRoom: ((WaitingRoomParticipant) -> Void)? // update waiting and joined participant when request accepted
    public var removeParicipantFromWaitingRoom: ((Bool) -> Void)? // remove participant when request rejected
    
    private let queue = DispatchQueue(label: "LiveKitSDK.room", qos: .default)
    
    public var connectionState: ConnectionState {
        room.connectionState
    }
    
    public var metadata: String? {
        room.metadata
    }
    
    public var remoteParticipants: [Sid: Participant] {
        Dictionary(uniqueKeysWithValues: room.remoteParticipants.map { (sid, participant) in (sid, participant) })
    }
    
    public var allParticipants: [Sid: Participant] {
        var result = remoteParticipants
        
        if let localParticipant = room.localParticipant {
            result.updateValue(localParticipant,
                               forKey: localParticipant.sid)
        }
        
        return result
    }
    
    @Published public var cameraTrackState: TrackPublishState = .notPublished()
    @Published public var microphoneTrackState: TrackPublishState = .notPublished()
    @Published public var screenShareTrackState: TrackPublishState = .notPublished()
    public var delegate: ParticipantPermissionUpdateDelegates?
    
    public init(store: ValueStore<Preferences>) {
        self.store = store
        room.add(delegate: self)
        
        self.url = store.value.url
        self.token = store.value.token
        self.e2ee = store.value.e2ee
        self.e2eeKey = store.value.e2eeKey
        self.simulcast = store.value.simulcast
        self.adaptiveStream = store.value.adaptiveStream
        self.dynacast = store.value.dynacast
        self.reportStats = store.value.reportStats
        self.autoSubscribe = store.value.autoSubscribe
        self.publish = store.value.publishMode
        self.shouldShowDisconnectReason = false
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    deinit {
        UIApplication.shared.isIdleTimerDisabled = false
        print("RoomContext.deinit")
    }
    
    @MainActor
    func connect() async throws -> Room {
        let connectOptions = ConnectOptions(
            autoSubscribe: !publish && autoSubscribe, // don't autosubscribe if publish mode
            publishOnlyMode: publish ? "publish_\(UUID().uuidString)" : nil
        )
        
        var e2eeOptions: E2EEOptions?
        if e2ee {
            let keyProvider = BaseKeyProvider(isSharedKey: true)
            keyProvider.setKey(key: e2eeKey)
            e2eeOptions = E2EEOptions(keyProvider: keyProvider)
        }
        
        let roomOptions = RoomOptions(
            defaultCameraCaptureOptions: CameraCaptureOptions(
                position: .front,
                dimensions: .h1080_169,
                fps: 30
            ),
            defaultScreenShareCaptureOptions: ScreenShareCaptureOptions(
                dimensions: .h1080_169,
                useBroadcastExtension: GlobalConfig.useBroadcastExtension
            ),
            defaultAudioCaptureOptions: AudioCaptureOptions(
                echoCancellation: true,
                noiseSuppression: true,
                autoGainControl: true,
                typingNoiseDetection: true,
                highpassFilter: true
            ),
            defaultVideoPublishOptions: VideoPublishOptions(
                encoding: VideoEncoding(
                    maxBitrate: 1_500_000,
                    maxFps: 30
                ),
                simulcastLayers: [
                    VideoParameters.presetH180_169,
                    VideoParameters.presetH360_169
                ]
            ),
            defaultAudioPublishOptions: AudioPublishOptions(
                dtx: true
            ),
            adaptiveStream: true,
            dynacast: true
        )
        
        
        return try await room.connect(url,
                                      token,
                                      connectOptions: connectOptions,
                                      roomOptions: roomOptions)
        
    }
    
    func disconnect() async throws {
        try await room.disconnect()
    }
    
    func sendMessage() {
        
        guard let localParticipant = room.localParticipant else {
            print("LocalParticipant doesn't exist")
            return
        }
        
        // Make sure the message is not empty
        guard !textFieldString.isEmpty else { return }
        
        let roomMessageobect = ExampleRoomMessageNew(text: textFieldString, senderSid: localParticipant.sid, senderIdentity: localParticipant.identity, type: nil, createdAt: nil, byUser: nil)
        
        let roomMessage = ExampleRoomMessage(messageId: UUID().uuidString,
                                             senderSid: localParticipant.sid,
                                             senderIdentity: localParticipant.identity,
                                             text: textFieldString)
        textFieldString = ""
        messages.append(roomMessageobect)
        
        do {
            let json = try jsonEncoder.encode(roomMessage)
            
            localParticipant.publish(data: json).then {
                print("did send data")
            }.catch { error in
                print("failed to send data \(error)")
            }
            
        } catch let error {
            print("Failed to encode data \(error)")
        }
    }
    
    func toggleScreenShareEnablediOS() {
        toggleScreenShareEnabled()
    }
    
    func toggleScreenShareDisablediOS() async {
        try? await unpublishAllLocalPaticipant()
    }
    
    func unpublishAll() async throws {
        toggleScreenShareEnabled()
        guard let localParticipant = self.room.localParticipant else { return }
        try await localParticipant.unpublishAll()
        Task { @MainActor in
            self.cameraTrackState = .notPublished()
            self.microphoneTrackState = .notPublished()
            self.screenShareTrackState = .notPublished()
        }
    }
    
    func unpublishAllLocalPaticipant() async throws {
        
        guard let localParticipant = self.room.localParticipant else { return }
        try await localParticipant.unpublishAll()
        
        Task { @MainActor in
            self.cameraTrackState = .notPublished()
            self.microphoneTrackState = .notPublished()
            self.screenShareTrackState = .notPublished()
        }
    }
    
    
    @discardableResult
    public func switchCameraPosition() -> Promise<Bool> {
        
        guard case .published(let publication) = self.cameraTrackState,
              let track = publication.track as? LocalVideoTrack,
              let cameraCapturer = track.capturer as? CameraCapturer else {
            //            log("Track or CameraCapturer doesn't exist", .notice)
            return Promise(TrackError.state(message: "Track or a CameraCapturer doesn't exist"))
        }
        
        return cameraCapturer.switchCameraPosition()
    }
    
    public func toggleCameraEnabled() {
        
        guard let localParticipant = room.localParticipant else {
            //log("LocalParticipant doesn't exist", .notice)
            return
        }
        
        guard !cameraTrackState.isBusy else {
            //log("cameraTrack is .busy", .notice)
            return
        }
        
        DispatchQueue.main.async {
            self.cameraTrackState = .busy(isPublishing: !self.cameraTrackState.isPublished)
        }
        
        localParticipant.setCamera(enabled: !localParticipant.isCameraEnabled()).then(on: queue) { publication in
            DispatchQueue.main.async {
                guard let publication = publication else { return }
                self.cameraTrackState = .published(publication)
            }
            //self.log("Successfully published camera")
        }.catch(on: queue) { error in
            DispatchQueue.main.async {
                self.cameraTrackState = .notPublished(error: error)
            }
            //self.log("Failed to publish camera, error: \(error)")
        }
    }
    
    public func toggleScreenShareEnabled() {
        
        guard let localParticipant = room.localParticipant else {
            //log("LocalParticipant doesn't exist", .notice)
            return
        }
        
        guard !screenShareTrackState.isBusy else {
            //log("screenShareTrack is .busy", .notice)
            return
        }
        
        DispatchQueue.main.async {
            self.screenShareTrackState = .busy(isPublishing: !self.screenShareTrackState.isPublished)
        }
        
        localParticipant.setScreenShare(enabled: !localParticipant.isScreenShareEnabled()).then(on: queue) { publication in
            DispatchQueue.main.async {
                guard let publication = publication else { return }
                self.screenShareTrackState = .published(publication)
            }
        }.catch(on: queue) { error in
            DispatchQueue.main.async {
                self.screenShareTrackState = .notPublished(error: error)
            }
        }
    }
    
    public func toggleMicrophoneEnabled() {
        guard let localParticipant = room.localParticipant else {
            //log("LocalParticipant doesn't exist", .notice)
            return
        }
        
        guard !microphoneTrackState.isBusy else {
            //log("microphoneTrack is .busy", .notice)
            return
        }
        
        DispatchQueue.main.async {
            self.microphoneTrackState = .busy(isPublishing: !self.microphoneTrackState.isPublished)
        }
        
        localParticipant.setMicrophone(enabled: !localParticipant.isMicrophoneEnabled()).then(on: queue) { publication in
            DispatchQueue.main.async {
                guard let publication = publication else { return }
                self.microphoneTrackState = .published(publication)
            }
            //self.log("Successfully published microphone")
        }.catch(on: queue) { error in
            DispatchQueue.main.async {
                self.microphoneTrackState = .notPublished(error: error)
            }
            //self.log("Failed to publish microphone, error: \(error)")
        }
    }
    
    
    private func getEventType(data: Data) -> String {
        
        do {
            guard let metadata = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("getEventType error")
                return ""
            }
            
            if let eventType = metadata[EventUtils.eventType] as? String {
                print("eventType: ", eventType)
                print("eventValue: ", metadata[EventUtils.eventValue] as? String ?? "")
                return eventType == EventUtils.typeMessage ? eventType : (metadata[EventUtils.eventValue] as? String ?? "")
            }
            
            return ""
            
        } catch let error as NSError {
            print("getEventType Failed to load: \(error.localizedDescription)")
            return ""
        }
    }
    
    private func getMessage(from data: Data) {
        do {
            let roomMessage = try jsonDecoder.decode(ExampleRoomMessageNew.self, from: data)
            
            self.getMessageCallback?(roomMessage)
            
            // Update UI from main queue
            DispatchQueue.main.async {
                withAnimation {
                    // Add messages to the @Published messages property
                    // which will trigger the UI to update
                    self.messages.append(roomMessage)
                    // Show the messages view when new messages arrive
                    self.showMessagesView = true
                }
            }
            
        } catch let error {
            print("Failed to decode data \(error)")
        }
    }
    
}

extension RoomContext: ParticipantDelegate {
    public func participant(_ participant: Participant, didUpdate permissions: ParticipantPermissions) {
        print("ParticipantContext participant: \(participant), didUpdate ParticipantPermissions canPublish: \(permissions.canPublish) canSubscribe: \(permissions.canSubscribe)")
    }
    
    public func participant(_ participant: RemoteParticipant, didUpdate publication: RemoteTrackPublication, permission allowed: Bool) {
        print("ParticipantContext participant: \(participant), didUpdate permission \(allowed)")
    }
    
    public func participant(_ participant: Participant, didUpdate publication: TrackPublication, muted: Bool) {
        print("ParticipantContext participant: \(participant), didUpdate muted \(muted)")
    }
    
    public func participant(_ participant: RemoteParticipant, didReceive data: Data) {
        print("participant ROOMVIEW DELEGATE CALLED didReceive data")
    }
    
    public func participant(_ participant: RemoteParticipant, didReceiveData data: Data, topic: String) {
        print("participant ROOMVIEW DELEGATE CALLED didReceiveData data: topic")
    }
}

extension RoomContext: RoomDelegate {
    
    public func room(_ room: Room, didUpdate connectionState: ConnectionState, oldValue: ConnectionState) {
        
        print("Did update connectionState \(oldValue) -> \(connectionState)")
        
        if case .disconnected(let reason) = connectionState, reason != .user {
            latestError = reason
            DispatchQueue.main.async {
                self.shouldShowDisconnectReason = true
                print("Reason: " + (self.latestError != nil
                                    ? String(describing: self.latestError!)
                                    : "Unknown"))
                self.meetingDisconnetCallback?((self.latestError != nil ? String(describing: self.latestError!) : "Unknown"))
            }
        }
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: .updateRoomObject, object: nil)
        }
    }
    
    public func room(_ room: Room, participant: RemoteParticipant?, didReceive data: Data) {
        
        print("did receive data \(data)")
        
        let eventType = getEventType(data: data)
        
        switch eventType {
        case EventUtils.typeMessage:
            print("event listened: typeMessage")
            self.getMessage(from: data)
        case EventUtils.typeRecordingStart:
            print("event listened: RecordingStart")
            self.recordingStatus?(true)
        case EventUtils.typeRecordingStop:
            print("event listened: RecordingStop")
            self.recordingStatus?(false)
        case EventUtils.typeTranscriptionStart:
            print("event listened: typeTranscriptionStart")
            self.transcriptionStatus?(true)
        case EventUtils.typeTranscriptionStop:
            print("event listened: typeTranscriptionStop")
            self.transcriptionStatus?(false)
        case EventUtils.requestRejected:
            print("event listened: requestRejected")
            self.removeParicipantFromWaitingRoom?(true)
        default:
            break
        }
    }
    
    public func room(_ room: Room, participantDidJoin participant: RemoteParticipant) {
        print("participantDidJoin  -> \(participant.name)")
        if !participant.permissions.canSubscribe {
            self.sendWaitingRequest?(participant)
        }
        
        let participantView = ParticipantView(participant: participant) { participant in}
        delegate?.remoteParticipantJoinedOrLeave(participant: participantView, trackType: .joined)
    }
    
    public func room(_ room: Room, participantDidLeave participant: RemoteParticipant) {
        print("participantDidLeave  -> \(participant.name)")
        
        let participantView = ParticipantView(participant: participant) { participant in
        }
        delegate?.remoteParticipantJoinedOrLeave(participant: participantView, trackType: .leave)
    }
    
    public func room(_ room: Room, participant: RemoteParticipant?, didReceiveData data: Data, topic: String) {
        print("ROOMVIEW DELEGATE CALLED - didReceiveData")
    }
    
    public func room(_ room: Room, didUpdate speakers: [Participant]) {
        print("didUpdate speakers  -> \(speakers)")
        if let firstSpeaker = room.activeSpeakers.first, firstSpeaker.isSpeaking  {
            delegate?.sepakingParticioant(pIdentity: firstSpeaker.identity, status: firstSpeaker.isSpeaking)
        }
    }
    
    public func room(_ room: Room, participant: Participant, didUpdate permissions: ParticipantPermissions) {
        print("Participant didUpdate permission \(participant.name) -> \(permissions)") // request accepted for joining
        if(permissions.canPublish && permissions.canSubscribe) {
            delegate?.participantPermissionDidUpdate(participantName: participant.name, permissionAllow: true)
        }
    }
    
    public func room(_ room: Room, participant: RemoteParticipant, didUpdate publication: RemoteTrackPublication, permission allowed: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.updateWaitingRoom?(WaitingRoomParticipant(participant: participant , isAllowed: allowed))
            self?.updateParticipantGrid = true
            if let firstIndex = self?.participantsList.firstIndex(where: { $0.participant.identity == participant.identity } ) {
                self?.participantsList[firstIndex].participant = participant
            }
            NotificationCenter.default.post(name: .updateRoomObject, object: nil)
        }
        print("Participant didUpdate permission \(publication.name) -> \(publication.subscriptionAllowed)") // request accepted for joining
    }
    
    public func participant(_ participant: RemoteParticipant, didUpdate publication: RemoteTrackPublication, streamState: StreamState) {
        print("Participant didUpdate StreamState \(publication.name) -> \(streamState)")
    }
    
    public func room(_ room: Room, participant: RemoteParticipant, didPublish publication: RemoteTrackPublication) {
        print("participant:\(participant) didPublish:\(publication)")
        Task.detached { @MainActor in
            NotificationCenter.default.post(name: .updateRoomObject, object: nil)
        }
    }
    
    public func room(_ room: Room, participant: RemoteParticipant, didUnpublish publication: RemoteTrackPublication) {
        print("participant:\(participant) didUnpublish:\(publication)")
        Task.detached { @MainActor in
            NotificationCenter.default.post(name: .updateRoomObject, object: nil)
        }
    }
    
    public func room(_ room: Room, localParticipant: LocalParticipant, didPublish publication: LocalTrackPublication) {
        
        print("ROOMVIEW DELEGATE CALLED - localParticipant didPublish : participant \(localParticipant.identity) : muted status - \(publication.track?.muted ?? false) : trackType - \(publication.track?.kind ?? .none)" )
        
        switch publication.track?.source ?? .none {
        case .microphone :
            delegate?.localParticipantChangeMuteStatus(pIdentity: localParticipant.identity, status: publication.track?.muted ?? false, trackType: .audio)
            
        case .camera :
            delegate?.localParticipantChangeMuteStatus(pIdentity: localParticipant.identity, status: publication.track?.muted ?? false, trackType: .video)
            
        case .screenShareVideo :
            delegate?.localParticipantChangeMuteStatus(pIdentity: localParticipant.identity, status: publication.track?.muted ?? false, trackType: .screenShare)
            
        case .unknown,.screenShareAudio:
            delegate?.localParticipantChangeMuteStatus(pIdentity: localParticipant.identity, status: publication.track?.muted ?? false, trackType: .none)
        case .none:
            break
        }
    }
    
    public func room(_ room: Room, localParticipant: LocalParticipant, didUnpublish publication: LocalTrackPublication) {
        print("participant:\(localParticipant) didUnpublish:\(publication)")
        switch publication.track?.source ?? .none {
        case .screenShareVideo :
            delegate?.localParticipantChangeMuteStatus(pIdentity: localParticipant.identity, status: true, trackType: .screenShare)
            
        default :
            break
            
        }
    }
    
    // ADD ADDITIONAL DELEGATE FOR TESTING
    public func room(_ room: Room, didUpdate connectionState: ConnectionStateObjC, oldValue oldConnectionState: ConnectionStateObjC) {
        print("ROOMVIEW DELEGATE CALLED - oldConnectionState")
    }
    
    /// Successfully connected to the room.
    public func room(_ room: Room, didConnect isReconnect: Bool) {
        print("ROOMVIEW DELEGATE CALLED - didConnect")
    }
    
    /// Could not connect to the room.
    public func room(_ room: Room, didFailToConnect error: Error) {
        print("ROOMVIEW DELEGATE CALLED - didFailToConnect")
    }
    
    /// Client disconnected from the room unexpectedly.
    public func room(_ room: Room, didDisconnect error: Error?) {
        print("ROOMVIEW DELEGATE CALLED - didDisconnect error")
    }
    
    /// ``Room``'s metadata has been updated.
    public func room(_ room: Room, didUpdate metadata: String?) {
        print("ROOMVIEW DELEGATE CALLED - didUpdate metadata Room")
    }
    
    /// ``Room``'s recording state has been updated.
    public func room(_ room: Room, didUpdate isRecording: Bool) {
        print("ROOMVIEW DELEGATE CALLED - isRecording")
    }
    
    /// Same with ``ParticipantDelegate/participant(_:didUpdate:)-46iut``.
    public func room(_ room: Room, participant: Participant, didUpdate metadata: String?) {
        print("ROOMVIEW DELEGATE CALLED - didUpdate metadata participant")
        
    }
    
    /// Same with ``ParticipantDelegate/participant(_:didUpdateName:)``.
    public func room(_ room: Room, participant: Participant, didUpdateName: String) {
        print("ROOMVIEW DELEGATE CALLED - didUpdateName")
    }
    
    /// Same with ``ParticipantDelegate/participant(_:didUpdate:)-7zxk1``.
    public func room(_ room: Room, participant: Participant, didUpdate connectionQuality: ConnectionQuality) {
        // print("ROOMVIEW DELEGATE CALLED - connectionQuality")
    }
    
    /// Same with ``ParticipantDelegate/participant(_:didUpdate:)-84m89``.
    public func room(_ room: Room, participant: Participant, didUpdate publication: TrackPublication, muted: Bool) {
        print("ROOMVIEW DELEGATE CALLED - didUpdate muted : participant \(participant.identity) : muted status - \(muted) : trackType - \(publication.track?.kind ?? .none)" )
        
        if(room.localParticipant?.identity == participant.identity) {
            
            switch publication.track?.source ?? .none {
            case .microphone :
                delegate?.localParticipantChangeMuteStatus(pIdentity: participant.identity, status: muted, trackType: .audio)
                
            case .camera :
                delegate?.localParticipantChangeMuteStatus(pIdentity: participant.identity, status: muted, trackType: .video)
                
            case .screenShareVideo :
                delegate?.localParticipantChangeMuteStatus(pIdentity: participant.identity, status: muted, trackType: .screenShare)
                
            case .unknown,.screenShareAudio:
                delegate?.localParticipantChangeMuteStatus(pIdentity: participant.identity, status: muted, trackType: .none)
            case .none:
                break
            }
            
        } else {
            switch publication.track?.source ?? .none {
            case .microphone :
                delegate?.remoteParticipantChangeMuteStatus(pIdentity: participant.identity, status: muted, trackType: .audio)
                
            case .camera :
                delegate?.remoteParticipantChangeMuteStatus(pIdentity: participant.identity, status: muted, trackType: .video)
                
            case .screenShareVideo :
                delegate?.remoteParticipantChangeMuteStatus(pIdentity: participant.identity, status: muted, trackType: .screenShare)
                
            case .unknown,.screenShareAudio:
                delegate?.remoteParticipantChangeMuteStatus(pIdentity: participant.identity, status: muted, trackType: .none)
            case .none:
                break
            }
        }
    }
    
    /// Same with ``ParticipantDelegate/participant(_:didUpdate:streamState:)-1lu8t``.
    public func room(_ room: Room, participant: RemoteParticipant, didUpdate publication: RemoteTrackPublication, streamState: StreamState) {
        //print("ROOMVIEW DELEGATE CALLED - didUpdate streamState ")
    }
    
    
    /// Same with ``ParticipantDelegate/participant(_:didSubscribe:track:)-7mngl``.
    public func room(_ room: Room, participant: RemoteParticipant, didSubscribe publication: RemoteTrackPublication, track: Track) {
        // print("ROOMVIEW DELEGATE CALLED - didSubscribe")
    }
    
    /// Same with ``ParticipantDelegate/participant(_:didFailToSubscribe:error:)-10pn4``.
    public func room(_ room: Room, participant: RemoteParticipant, didFailToSubscribe trackSid: String, error: Error) {
        print("ROOMVIEW DELEGATE CALLED - didFailToSubscribe")
    }
    
    /// Same with ``ParticipantDelegate/participant(_:didUnsubscribe:track:)-3ksvp``.
    public func room(_ room: Room, participant: RemoteParticipant, didUnsubscribe publication: RemoteTrackPublication, track: Track) {
        print("ROOMVIEW DELEGATE CALLED - didUnsubscribe")
    }
    
    /// ``Room``'e2ee state has been updated.
    public func room(_ room: Room, publication: TrackPublication, didUpdateE2EEState: E2EEState) {
        print("ROOMVIEW DELEGATE CALLED - didUpdateE2EEState")
    }
}

