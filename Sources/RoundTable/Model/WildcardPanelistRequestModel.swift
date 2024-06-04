//
//  WildcardPanelistRequestModel.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 28/11/23.
//

import Foundation

public enum WildcardPanelistRequestAction: String {
    case accept = "ACCEPT"
    case reject = "REJECT"
}

public struct WildcardPanelistRequestModel: Codable {
    
    public var data    : WildcardPanelistRequestDataModel? = WildcardPanelistRequestDataModel()
    public var error   : String? = nil
    public var message : String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case data    = "data"
        case message = "message"
        case error
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data    = try values.decodeIfPresent(WildcardPanelistRequestDataModel.self   , forKey: .data    )
        message = try values.decodeIfPresent(String.self , forKey: .message )
        error = try values.decodeIfPresent(String.self , forKey: .error )
    }
    
    public init() {
        
    }
}

public struct WildcardPanelistRequestDataModel: Codable {
    
    public var actionBy         : String? = nil
    public var roomId           : String? = nil
    public var userId           : String? = nil
    public var wildCardUserid   : String? = nil
    public var wildCardUsername : String? = nil
    
    public enum CodingKeys: String, CodingKey {
        
        case actionBy         = "action_by"
        case roomId           = "roomId"
        case userId           = "userId"
        case wildCardUserid   = "wild_card_userid"
        case wildCardUsername = "wild_card_username"
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        actionBy         = try values.decodeIfPresent(String.self , forKey: .actionBy         )
        roomId           = try values.decodeIfPresent(String.self , forKey: .roomId           )
        userId           = try values.decodeIfPresent(String.self , forKey: .userId           )
        wildCardUserid   = try values.decodeIfPresent(String.self , forKey: .wildCardUserid   )
        wildCardUsername = try values.decodeIfPresent(String.self , forKey: .wildCardUsername )
        
    }
    
    public init() {
        
    }
}
