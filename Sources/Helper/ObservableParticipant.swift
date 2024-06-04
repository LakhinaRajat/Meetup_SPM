//
//  Participant.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 13/09/23.
//

import Foundation
import SwiftUI
import WebRTC
import LiveKit

extension ObservableParticipant: ParticipantDelegate {

    public func participant(_ participant: RemoteParticipant,
                            didSubscribe trackPublication: RemoteTrackPublication,
                            track: Track) {
        // log("\(self.hashValue) didSubscribe remoteTrack: \(String(describing: track.sid))")
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    public func participant(_ participant: RemoteParticipant,
                            didUnsubscribe trackPublication: RemoteTrackPublication,
                            track: Track) {
//        log("\(self.hashValue) didUnsubscribe remoteTrack: \(String(describing: track.sid))")
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    public func participant(_ participant: RemoteParticipant,
                            didUpdate publication: RemoteTrackPublication,
                            permission allowed: Bool) {
//        log("\(self.hashValue) didUpdate allowed: \(allowed)")
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    public func localParticipant(_ participant: LocalParticipant,
                                 didPublish trackPublication: LocalTrackPublication) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    public func localParticipant(_ participant: LocalParticipant,
                                 didUnpublish trackPublication: LocalTrackPublication) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    public func participant(_ participant: Participant,
                            didUpdate trackPublication: TrackPublication,
                            muted: Bool) {
//        log("\(self.hashValue) didUpdate muted: \(muted)")
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    public func participant(_ participant: Participant, didUpdate speaking: Bool) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    public func participant(_ participant: Participant, didUpdate connectionQuality: ConnectionQuality) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension ObservableParticipant: Identifiable {
    public var id: String {
        participant.sid
    }
}

extension ObservableParticipant: Equatable, Hashable {

    public static func == (lhs: ObservableParticipant, rhs: ObservableParticipant) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ObservableParticipant {

    public var sid: Sid {
        participant.sid
    }

    public var identity: String {
        participant.identity
    }
}

open class ObservableParticipant: ObservableObject {

    public let participant: Participant

    public var asLocal: LocalParticipant? {
        participant as? LocalParticipant
    }

    public var asRemote: RemoteParticipant? {
        participant as? RemoteParticipant
    }

    public var isSpeaking: Bool {
        participant.isSpeaking
    }

    public var joinedAt: Date? {
        participant.joinedAt
    }

    public var connectionQuality: ConnectionQuality {
        participant.connectionQuality
    }

    public init(_ participant: Participant) {
        self.participant = participant
        participant.add(delegate: self)
    }
}
