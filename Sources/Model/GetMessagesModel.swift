//
//  GetMessagesModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 20/07/23.
//

import Foundation


// MARK: - GetMessagesModel
public struct GetMessagesModel: Codable {
    public let message: String?
    public let messageData: MessageObject?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case messageData = "data"
    }
}

// MARK: - DataClass
public struct MessageObject: Codable {
    public let messages: [LKMessage]?
    public let count: Int?

    enum CodingKeys: String, CodingKey {
        case messages = "messages"
        case count = "count"
    }
}

// MARK: - Message
public struct LKMessage: Codable {
    public let id: String?
    public let message: String?
    public let by: MessageBy?
    public let meetingID: String?
    public let deleted: Bool?
    public let createdAt: String?
    public let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case message = "message"
        case by = "by"
        case meetingID = "meetingId"
        case deleted = "deleted"
        case createdAt = "created_at"
        case v = "__v"
    }
}

// MARK: - By
public struct MessageBy: Codable {
   public let id: String?
   public let name: String?
   public let username: String?
   public let userID: String?
   public let anonymous: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case username = "username"
        case userID = "userId"
        case anonymous = "anonymous"
    }
}
