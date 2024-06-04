//
//  CalendarModel.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 01/09/23.
//

import Foundation

// MARK: - Welcome
public struct CalendarModel: Codable {
    public let message: String?
    public let data: [CalendarData]?
}

// MARK: - Datum
public struct CalendarData: Codable {
    public let id, name: String?
    public let moderator: ModeratorData?
    public let registeredOnly: Bool?
    public let start, end: String?
    public let deleted: Bool?
    public let recording: RecordingClass?
    public let transcripting: transcriptingClass?
    public let waitingLounge, freeUser: Bool?
    public let invitedUsers: [InvitedUser]?
    public let simulcastEnabled: [String]?
    public let meetingID, updatedAt: String?
    public let v: Int?
    public let simulCasting: SimulCasting?
    public let passcode: Bool?
    public let pin: String?
    public let isTranscripted: Bool?
    public let isRecorded: Bool?
    public let media: Media?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, moderator
        case registeredOnly = "registered-only"
        case start, end, deleted, recording, transcripting, waitingLounge, freeUser, invitedUsers, simulcastEnabled
        case meetingID = "meetingId"
        case updatedAt = "updated_at"
        case v = "__v"
        case simulCasting, passcode, pin
        case isTranscripted = "isTranscripted"
        case isRecorded = "isRecorded"
        case media = "media"
    }
}

// MARK: - Moderator
public struct ModeratorData: Codable {
    public let id, name, username, userID: String?
    public let anonymous: Bool?
    public let speakersCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, username
        case userID = "userId"
        case anonymous, speakersCount
    }
}
//
//public enum RecordingUnion: Codable {
//    case bool(Bool)
//    case recordingClass(RecordingClass)
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode(Bool.self) {
//            self = .bool(x)
//            return
//        }
//        if let x = try? container.decode(RecordingClass.self) {
//            self = .recordingClass(x)
//            return
//        }
//        throw DecodingError.typeMismatch(RecordingUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for RecordingUnion"))
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//            case .bool(let x):
//                try container.encode(x)
//            case .recordingClass(let x):
//                try container.encode(x)
//        }
//    }
//}

// MARK: - RecordingClass
public struct RecordingClass: Codable {
    public let value: Bool?
    public let egressID: String?
    
    enum CodingKeys: String, CodingKey {
        case value
        case egressID = "egressId"
    }
}

// MARK: - transcriptingClass
public struct transcriptingClass: Codable {
    public let value: Bool?
    public let transcriptionId: String?
    
    enum CodingKeys: String, CodingKey {
        case value
        case transcriptionId
    }
}

// MARK: - SimulCasting
public struct SimulCasting: Codable {
    
}
