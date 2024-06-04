////
////  MeetNotificationModel.swift
////  LoktantramMeetup
////
////  Created by Loktantram on 06/02/24.
////
//
import Foundation

public enum MettingStatus: String, Codable {
    case ACCEPTED
    case TENTATIVE
    case REJECTED
    case NO_RESPONSE
}

// MARK: - MeetNotificationModel
public struct MeetNotificationModel: Codable {
    public let message: String?
    public let data: [MeetNotification]?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}

//// MARK: - Datum
public struct MeetNotification: Codable {
    public let id: String?
    public let title: String?
    public let body: String?
    public let by: String?
    public let errorMsg: String?
    public let roomID: String?
    public let isStatus: Bool?
    public let createdAt: String?
    public let updatedAt: String?
    public let v: Int?
    public let room: RoomItem?
    public let moderator: Moderator?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title = "title"
        case body = "body"
        case by = "by"
        case errorMsg = "errorMsg"
        case roomID = "roomId"
        case isStatus = "isStatus"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case v = "__v"
        case room = "room"
        case moderator = "moderator"
    }
}

//// MARK: - Room
public struct RoomItem: Codable {
    public let id: String?
    public let name: String?
    public let pin: String?
    public let passcode: Bool?
    public let start: String?
    public let end: String?
    public let deleted: Bool?
    public let invitedUsers: [InvitedUserItem]?
    public let meetingID: String?
    public let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case pin = "pin"
        case passcode = "passcode"
        case start = "start"
        case end = "end"
        case deleted = "deleted"
        case invitedUsers = "invitedUsers"
        case meetingID = "meetingId"
        case createdAt = "created_at"
    }
}
//
//// MARK: - InvitedUser
public struct InvitedUserItem: Codable {
    public let name: String?
    public let username: String?
    public let userID: String?
    public let fcmToken: [String]?
    public let status: MettingStatus?
    public let timestamp: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case username = "username"
        case userID = "userId"
        case fcmToken = "fcmToken"
        case status = "status"
        case timestamp = "timestamp"
    }
}
