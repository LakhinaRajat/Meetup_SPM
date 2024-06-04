//
//  AuthTokenModel.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 16/10/23.
//

import Foundation

public struct AuthTokenModel: Codable {
    public let data: String?
    public let error: String?
    public let message: String?
    
    enum CodingKeys: String, CodingKey {
        case data, message, error
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

public struct RTJoiningTokenModel: Codable {
    public let data: RTTokenDataModel?
    public let error: String?
    public let message: String?
    
    enum CodingKeys: String, CodingKey {
        case data, message, error
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(RTTokenDataModel.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

public struct RTTokenDataModel: Codable {
    public let textMessage: String?
    public let error: String?
    public let token: String?
    
    enum CodingKeys: String, CodingKey {
        case textMessage = "text"
        case token, error
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        textMessage = try values.decodeIfPresent(String.self, forKey: .textMessage)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}

// Health Check
public struct HealthCheckModel: Codable {
    public let data: HealthCheckData
    public let error: String?
    public let message: String
}

// MARK: - DataClass
public struct HealthCheckData: Codable {
    public let postgressDB, redis: String

    enum CodingKeys: String, CodingKey {
        case postgressDB = "Postgress-DB"
        case redis = "Redis"
    }
}

// Like Dislike RT
public struct RTLikeDislikeModel: Codable {
    public var data: RTLikeDislikeData? = nil
    public let error: String?
    public var message: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case data, message, error
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(RTLikeDislikeData.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

public struct RTLikeDislikeData: Codable {
    public var likeCount: Int?
    public var dislikeCount: Int?
    public var rtID: String?
    public var userId: String?
    public var username: String?

    enum CodingKeys: String, CodingKey {
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
        case userId = "user_id"
        case rtID = "rt_id"
        case username
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount)
        dislikeCount = try values.decodeIfPresent(Int.self, forKey: .dislikeCount)
        rtID = try values.decodeIfPresent(String.self, forKey: .rtID)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        username = try values.decodeIfPresent(String.self, forKey: .username)
    }
}

public struct RTPollModel: Codable {
    public var data: RTPollDataModel? = nil
    public var error: String? = nil
    public var message: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case data, message, error
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(RTPollDataModel.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

public struct RTPollDataModel: Codable {
    public var postId: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case postId
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decodeIfPresent(String.self, forKey: .postId)
    }
}


// Get RoundTable data -
public struct RoundTableModel: Codable {
    public let data: [RoundTableData]
    public let message: String
}

public struct RoundTableData: Codable {
    public let category: String?
    public let confirmationTime: Date
    public let createdAt: String
    public let deletedAt: JSONNull?
    public let description: String
    public let dislikeCount: Int
    public let end, id: String
    public let isConfirmed: JSONNull?
    public let isDeleted: Bool
    public let isModeratoConfirmed, isModeratorConfirmed: Int?
    public let isOwnerAnonymous: Bool
    public let isStarted, likeCount: Int
    public let moderatorID, name, openToAll, ownerID: String
    public let roundtableID, start: String
    public let startedAt: Date
    public let thumbnailURL, type, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case category
        case confirmationTime = "confirmation_time"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case description
        case dislikeCount = "dislike_count"
        case end, id
        case isConfirmed = "is_confirmed"
        case isDeleted = "is_deleted"
        case isModeratoConfirmed = "is_moderato_confirmed"
        case isModeratorConfirmed = "is_moderator_confirmed"
        case isOwnerAnonymous = "is_owner_anonymous"
        case isStarted = "is_started"
        case likeCount = "like_count"
        case moderatorID = "moderator_id"
        case name
        case openToAll = "open_to_all"
        case ownerID = "owner_id"
        case roundtableID = "roundtable_id"
        case start
        case startedAt = "started_at"
        case thumbnailURL = "thumbnail_url"
        case type
        case updatedAt = "updated_at"
    }
}

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool { return true }
    public var hashValue: Int {
        return 0
    }
    public init() {}
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

// Get post by id -

// MARK: - Welcome
public struct RTPostsModel: Codable {
    public let data: [RTPostsData]
    public let message: String
}

// MARK: - Datum
public struct RTPostsData: Codable {
    public let action: String?
    public let createdAt: String
    public let deletedAt: String?
    public let dislikeCount: Int
    public let hashTags: [String]?
    public let id: String
    public let keywords: [String]?
    public let lang: String
    public let likeCount, likes: Int
    public let mediaType: String
    public let parentPostID: String?
    public let repost: Int
    public let roundtableID: String
    public let text: String
    public let topics: [String]?
    public let type: String
    public let updatedAt: String
    public let urls: [String]?
    public let userID: String

    enum CodingKeys: String, CodingKey {
        case action
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case dislikeCount = "dislike_count"
        case hashTags = "hash_tags"
        case id, keywords, lang
        case likeCount = "like_count"
        case likes
        case mediaType = "media_type"
        case parentPostID = "parent_post_id"
        case repost
        case roundtableID = "roundtable_id"
        case text, topics, type
        case updatedAt = "updated_at"
        case urls
        case userID = "user_id"
    }
}


//Create post text message response model
public struct PostTextMessageResponseModel: Codable {
    public let data: PostTextMessageRespData?
    public let message: String?
}

public struct PostTextMessageRespData: Codable {
    public var postId: String?
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decodeIfPresent(String.self, forKey: .postId)
    }
}
