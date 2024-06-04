//
//  JoinedMeetingModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 05/07/23.
//

import Foundation

// MARK: - JoinedMeetingModel
public struct JoinedMeetingModel: Codable {
    public let message: String?
    public let data: JoinedMeetingData?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
public struct JoinedMeetingData: Codable {
    public let id: String?
    public let name: String?
    public let moderator: Moderator?
    public let pin: String?
    public let passcode: Bool?
    public let registeredOnly: Bool?
    public let start: String?
    public let end: String?
    public let deleted: Bool?
    public let recording: RecordingClass?
    public let transcripting: transcriptingClass?
    public let waitingLounge: Bool?
    public let freeUser: Bool?
    public let invitedUsers: [InvitedUser]?
    public let meetingID: String?
    public let v: Int?
    public let token: String?
    public let media: Media?

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
        case waitingLounge = "waitingLounge"
        case freeUser = "freeUser"
        case invitedUsers = "invitedUsers"
        case meetingID = "meetingId"
        case v = "__v"
        case token = "token"
        case media = "media"
    }
}

public struct InvitedUser: Codable {
    public let userId: String?
    public let name: String?
    public let username: String?
    public let fcmToken: [String]?
    public let status: MettingStatus?
    public let timestamp: String?
}
