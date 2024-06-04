//
//  MeetingDetailModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 16/01/24.
//

import Foundation

// MARK: - MeetingDetailModel
public struct MeetingDetailModel: Codable {
    public let message: String?
    public let data: MeetingDetailData?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
public struct MeetingDetailData: Codable {
    public let id: String?
    public let name: String?
    public let moderator: Moderator?
    public let pin: String?
    public let passcode: Bool?
    public let registeredOnly: Bool?
    public let start: String?
    public let end: String?
    public let deleted: Bool?
    public let recording: PurpleRecording?
    public let transcripting: transcriptingClass?
    public let prevMeetingsDate: [String]?
    public let waitingLounge: Bool?
    public let freeUser: Bool?
    public let invitedUsers: [InvitedUser]?
    public let simulcastEnabled: [String]?
    public let inviteParticipants: InviteParticipants?
    public let meetingID: String?
    public let media: Media?
    public let createdAt: String?
    public let updatedAt: String?
    public let v: Int?
    public let transcriptingStartedUserID: String?
    public let dataID: String?
    public let recordings: [RecordingElement]?
    public let transcriptions: [TranscriptionUrl]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case moderator = "moderator"
        case pin = "pin"
        case passcode = "passcode"
        case registeredOnly = "registered-only"
        case start = "start"
        case end = "end"
        case deleted = "deleted"
        case recording = "recording"
        case transcripting = "transcripting"
        case prevMeetingsDate = "prev_meetings_date"
        case waitingLounge = "waitingLounge"
        case freeUser = "freeUser"
        case invitedUsers = "invitedUsers"
        case simulcastEnabled = "simulcastEnabled"
        case inviteParticipants = "inviteParticipants"
        case meetingID = "meetingId"
        case media = "media"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case v = "__v"
        case transcriptingStartedUserID = "transcripting_started_userId"
        case dataID = "id"
        case recordings = "recordings"
        case transcriptions = "transcriptions"
    }
}

// MARK: - InviteParticipants
public struct InviteParticipants: Codable {
    public let emails: [String]?

    enum CodingKeys: String, CodingKey {
        case emails = "emails"
    }
}

// MARK: - Media
public struct Media: Codable {
    public let logo1: String?
    public let logo2: String?
    public let logo3: String?
    public let doc: String?
    public let intro: String?
    public let outro: String?
    enum CodingKeys: String, CodingKey {
        case logo1 = "logo1"
        case logo2 = "logo2"
        case logo3 = "logo3"
        case doc = "doc"
        case intro = "intro"
        case outro = "outro"
    }
}

// MARK: - PurpleRecording
public struct PurpleRecording: Codable {
    public let value: Bool?
    public let egressID: String?

    enum CodingKeys: String, CodingKey {
        case value = "value"
        case egressID = "egressId"
    }
}

// MARK: - RecordingElement
public struct RecordingElement: Codable {
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

// MARK: - TranscriptionUrl
public struct TranscriptionUrl: Codable {
    public let transcriptionID: String?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case transcriptionID = "transcriptionId"
        case url = "url"
    }
}
