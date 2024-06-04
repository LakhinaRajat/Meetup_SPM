//
//  UserModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 04/07/23.
//

// MARK: - UserModel
public struct UserModel: Codable {
    public let id, name, userID, username: String?
    public let isAnonymousr: Bool?
    public let meetingId: String?
    public let fcmToken: [String]?
    public let version: Int?
    public let notificationCount: Int?
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case userID = "userId"
        case username
        case isAnonymousr = "anonymous"
        case meetingId
        case fcmToken
        case version = "__v"
        case notificationCount = "notification_count"
        case message 
    }
}



