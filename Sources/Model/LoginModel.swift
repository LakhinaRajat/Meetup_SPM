//
//  LoginModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 11/04/24.
//

import Foundation

// MARK: - LoginModel
public struct LoginModel: Codable {
    public let message: String?
    public let data: LoginResponse?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
public struct LoginResponse: Codable {
    public let user: LoginUser?
    public let sessionToken: String?
    public let accessToken: String?

    enum CodingKeys: String, CodingKey {
        case user = "user"
        case sessionToken = "sessionToken"
        case accessToken = "accessToken"
    }
}

// MARK: - User
public struct LoginUser: Codable {
    public let id: String?
    public let name: String?
    public let username: String?
    public let meetingID: String?
    public let userID: String?
    public let anonymous: Bool?
    public let speakersCount: Int?
    public let createdAt: String?
    public let updatedAt: String?
    public let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case username = "username"
        case meetingID = "meetingId"
        case userID = "userId"
        case anonymous = "anonymous"
        case speakersCount = "speakersCount"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case v = "__v"
    }
}
