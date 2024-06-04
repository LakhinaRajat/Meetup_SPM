//
//  WildcardUsersDataModel.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 14/12/23.
//

import Foundation

public struct WildcardDataModel: Codable {
    public var data: [WildcardData]? = nil
    public var message: String? = nil
    public var error: String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case data    = "data"
        case message = "message"
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data    = try values.decodeIfPresent([WildcardData].self   , forKey: .data    )
        message = try values.decodeIfPresent(String.self , forKey: .message )
        error = try values.decodeIfPresent(String.self , forKey: .error )
    }
    
    init() {
        
    }
}

// MARK: - Datum
public struct WildcardData: Codable {
    public var createdAt: String? = nil
    public var deletedAt: String? = nil
    public var id: String? = nil
    public var invitationMediumType: String? = nil
    public var invitedBy: String? = nil
    public var roundtableID: String? = nil
    public var updatedAt: String? = nil
    public var userID: String? = nil
    public var wildcardUser: WildcardUser? = nil
    public var wildcardCreatedAt: String? = nil
    public var isPending: Bool? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case createdAt    = "created_at"
        case deletedAt    = "deleted_at"
        case id
        case invitationMediumType    = "invitation_medium_type"
        case invitedBy    = "invited_by"
        case roundtableID    = "roundtable_id"
        case updatedAt    = "updated_at"
        case userID    = "user_id"
        case wildcardUser    = "wildcard-user"
        case wildcardCreatedAt    = "wildcard_created_at"
        case isPending = "is_pending"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        createdAt    = try values.decodeIfPresent(String.self   , forKey: .createdAt    )
        deletedAt = try values.decodeIfPresent(String.self , forKey: .deletedAt )
        id = try values.decodeIfPresent(String.self , forKey: .id )
        invitationMediumType    = try values.decodeIfPresent(String.self   , forKey: .invitationMediumType    )
        invitedBy = try values.decodeIfPresent(String.self , forKey: .invitedBy )
        roundtableID = try values.decodeIfPresent(String.self , forKey: .roundtableID )
        updatedAt    = try values.decodeIfPresent(String.self   , forKey: .updatedAt    )
        userID = try values.decodeIfPresent(String.self , forKey: .userID )
        wildcardCreatedAt = try values.decodeIfPresent(String.self , forKey: .wildcardCreatedAt )
        wildcardUser = try values.decodeIfPresent(WildcardUser.self , forKey: .wildcardUser )
        isPending = try values.decodeIfPresent(Bool.self, forKey: .isPending)
    }
    
    init() {
        
    }
}

// MARK: - WildcardUser
public struct WildcardUser: Codable {
    public var name: String? = nil
    public var username: String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case name
        case username
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decodeIfPresent(String.self , forKey: .name )
        username = try values.decodeIfPresent(String.self , forKey: .username )
    }
}
