//
//  PanelistMessageModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 21/11/23.
//

import Foundation

public struct RTPanelistMessageListModel: Codable {
    public let data: [PanelistMessageData]?
    public let message: String?
    public let total: Int?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case total = "total"
    }
}

// MARK: - RTPanelistMessageModel
public struct RTPanelistMessageModel: Codable {
    public let data: PanelistMessageData?
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
    }
}

// MARK: - PanelistMessageData
public struct PanelistMessageData: Codable {
    public let roundtableID: String?
    public let text: String?
    public let sendBy: String?
    public let username: String?
    public let createdAt: String?
    public let mediaUrls: String?

    enum CodingKeys: String, CodingKey {
        case roundtableID = "roundtable_id"
        case text = "text"
        case sendBy = "user_id"
        case username = "username"
        case createdAt = "created_at"
        case mediaUrls = "media-urls"
    }
}
