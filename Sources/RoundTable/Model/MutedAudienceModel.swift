//
//  MutedAudienceModel.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 28/11/23.
//

import Foundation
public struct MutedAudienceModel: Codable {
    
    public var data    : [MutedAudienceDataModel]? = []
    public var error : String? = nil
    public var message : String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case data    = "data"
        case message = "message"
        case error   = "error"
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data    = try values.decodeIfPresent([MutedAudienceDataModel].self , forKey: .data    )
        message = try values.decodeIfPresent(String.self , forKey: .message )
        error   = try values.decodeIfPresent(String.self , forKey: .error )
    }
    
    public init() {
        
    }
    
}

public struct MutedAudienceDataModel: Codable {
    
    public var name     : String? = nil
    public var userId   : String? = nil
    public var username : String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case name     = "name"
        case userId   = "user_id"
        case username = "username"
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name     = try values.decodeIfPresent(String.self , forKey: .name     )
        userId   = try values.decodeIfPresent(String.self , forKey: .userId   )
        username = try values.decodeIfPresent(String.self , forKey: .username )
        
    }
    
    public init() {
        
    }
    
}
