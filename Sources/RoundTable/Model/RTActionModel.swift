//
//  RTActionModel.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 28/11/23.
//

import Foundation

public enum RTActions: String {
    case like = "LIKE"
    case dislike = "DISLIKE"
    case wildcardPost = "wildcard_post"
    case staredPost = "starred_post"
    case circulate = "CIRCULATE"
    case poll = "POLL"
}

public struct RTPollVoteActionModel: Codable {
    public var data: [String]? = nil
    public var error: String? = nil
    public var message: String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case data    = "data"
        case error
        case message = "message"
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data    = try values.decodeIfPresent([String].self   , forKey: .data    )
        message = try values.decodeIfPresent(String.self , forKey: .message )
        error = try values.decodeIfPresent(String.self , forKey: .error )
    }
    
    init() {
        
    }
}

public struct RTActionModel: Codable {
    public var data: RTActionDataModel? = nil
    public var message: String? = nil
    public var error: String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case data    = "data"
        case message = "message"
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data    = try values.decodeIfPresent(RTActionDataModel.self   , forKey: .data    )
        message = try values.decodeIfPresent(String.self , forKey: .message )
        error = try values.decodeIfPresent(String.self , forKey: .error )
        
    }
    
    init() {
        
    }
}

public struct RTActionDataModel: Codable {
    public var action       : String? = nil
    public var dislikeCount : Int?    = nil
    public var likeCount    : Int?    = nil
    public var postId       : String? = nil
    public var username     : String? = nil
    
    public enum CodingKeys: String, CodingKey {
        case action       = "action"
        case dislikeCount = "dislike_count"
        case likeCount    = "like_count"
        case postId       = "post_id"
        case username     = "username"
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        action       = try values.decodeIfPresent(String.self, forKey: .action)
        dislikeCount = try values.decodeIfPresent(Int.self    , forKey: .dislikeCount )
        likeCount    = try values.decodeIfPresent(Int.self    , forKey: .likeCount    )
        postId       = try values.decodeIfPresent(String.self , forKey: .postId       )
        username     = try values.decodeIfPresent(String.self , forKey: .username     )
        
    }
    
    public init() {
        
    }
}

public struct RTCirculateActionModel: Codable {
    public var data: RTCirculateActionDataModel? = nil
    public var message: String? = nil
    public var error: String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case data    = "data"
        case message = "message"
        case error
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data    = try values.decodeIfPresent(RTCirculateActionDataModel.self   , forKey: .data    )
        message = try values.decodeIfPresent(String.self , forKey: .message )
        error = try values.decodeIfPresent(String.self , forKey: .error )
        
    }
    
    init() {
        
    }
}

public struct RTCirculateActionDataModel: Codable {
    public var circulateCount : Int?    = nil
    public var rtId           : String? = nil
    public var postId         : String? = nil
    public var username       : String? = nil
    public var userId         : String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case circulateCount = "circulate_count"
        case rtId           = "rt_id"
        case postId         = "post_id"
        case username       = "username"
        case userId         = "user_id"
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        circulateCount = try values.decodeIfPresent(Int.self    , forKey: .circulateCount )
        rtId           = try values.decodeIfPresent(String.self , forKey: .rtId           )
        postId         = try values.decodeIfPresent(String.self , forKey: .postId         )
        username       = try values.decodeIfPresent(String.self , forKey: .username       )
        userId         = try values.decodeIfPresent(String.self , forKey: .userId         )
        
    }
    
    public init() {
        
    }
}
