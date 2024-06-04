//
//  MeetingModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 04/07/23.
//

import Foundation

// MARK: - MeetingModel
public struct MeetingModel: Codable {
    public let message: String?
    public let data: MeetingData?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}


// MARK: - DataClass
public struct MeetingData: Codable {
    public  let id: String?
    public let name: String?
    public let meetingID: String?
    public let moderator: Moderator?
    public let registeredOnly: Bool?
    public let deleted: Bool?
    public let recording: RecordingClass?
    public let transcripting: transcriptingClass?
    public let createdAt: String?
    public let prevMeetingsDate: [String]?
    public let waitingLounge: Bool?
    public let freeUser: Bool?
    public let passcode: Bool?
    public let pin: String?
    public let start, end: String?
    public let media: Media?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case meetingID = "meetingId"
        case moderator = "moderator"
        case registeredOnly = "registered-only"
        case deleted = "deleted"
        case recording = "recording"
        case transcripting = "transcripting"
        case createdAt = "created_at"
        case prevMeetingsDate = "prev_meetings_date"
        case waitingLounge = "waitingLounge"
        case freeUser = "freeUser"
        case passcode, pin , start, end, media
    }
}

public struct Moderator: Codable {
    public let id: String?
    public let name: String?
    public let username: String?
    public let meetingID: String?
    public let userID: String?
    public let anonymous: Bool?
    public let v: Int?
    public let speakersCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case username = "username"
        case meetingID = "meetingId"
        case userID = "userId"
        case anonymous = "anonymous"
        case v = "__v"
        case speakersCount = "speakersCount"
    }
}

// MARK: - Recording
public struct Recording: Codable {
    let value: Bool?
    let egressID: String?

    enum CodingKeys: String, CodingKey {
        case value = "value"
        case egressID = "egressId"
    }
}
