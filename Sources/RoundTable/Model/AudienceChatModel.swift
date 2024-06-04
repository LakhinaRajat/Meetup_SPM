//
//  File.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 21/11/23.
//

import Foundation

public struct RTAudienceChatListModel: Codable {
    public let data: [AudienceChatData]?
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
    }
}

// MARK: - RTAudienceChatModel
public struct RTAudienceChatModel: Codable {
    public let data: AudienceChatData?
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
    }
}

// MARK: - AudienceChatData
public struct AudienceChatData: Codable {
    public let id: String?
    public let roundtableID: String?
    public let text: String?
    public let userID: String?
    public let username: String?
    public let name: String?
    public let createdAt: String?
    public let mediaUrls: String?
    public let mediaType: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case roundtableID = "roundtable_id"
        case text = "text"
        case userID = "user_id"
        case username = "username"
        case name = "name"
        case createdAt = "created_at"
        case mediaUrls = "media-urls"
        case mediaType = "media_type"
    }
}



// MARK: - RaisdHandUserListModel
public struct RaisdHandUserListModel: Codable {
    public let data: [RaisdHandUserList]?
    public let message: String?
    public let total: Int?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case total = "total"
    }
}

// MARK: - Datum
public struct RaisdHandUserList: Codable {
    public let userID: String?
    public let username: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username = "username"
    }
}

