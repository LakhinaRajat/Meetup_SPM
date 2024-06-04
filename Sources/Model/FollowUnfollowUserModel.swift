//
//  FollowUnfollowUserModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 28/07/23.
//

import Foundation


public struct FollowUnfollowUserModel: Codable {
    public var data: [ListFollowrs]?
    public let status: Int?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case status = "status"
    }
}

public struct ListFollowrs: Codable {
    public let id: String?
    public let username: String?
    public let name: String?
    public let email: String?
    public let profilePhoto: [String]?
    public let youFollow: Bool?
    public let follower: Bool?
    public let muted: Bool?
    public let blocked: Bool?
    public let selfFlag: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username = "username"
        case name = "name"
        case email = "email"
        case profilePhoto = "profile_photo"
        case youFollow = "you_follow"
        case follower = "follower"
        case muted = "muted"
        case blocked = "blocked"
        case selfFlag = "self_flag"
    }
}
