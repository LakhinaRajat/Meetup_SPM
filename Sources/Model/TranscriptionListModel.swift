//
//  TranscriptionListModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 16/01/24.
//

import Foundation


// MARK: - TranscriptionListModel
public struct TranscriptionListModel: Codable {
   public let message: String?
   public let data: TranscriptionModel?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
public struct TranscriptionModel: Codable {
    public let count: Int?
    public let transcriptions: [Transcription]?

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case transcriptions = "transcriptions"
    }
}

// MARK: - Transcription
public struct Transcription: Codable {
    public let transcript: String?
    public let transcriptionID: String?
    public let speaker: Speaker?
    public let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case transcript = "transcript"
        case transcriptionID = "transcriptionId"
        case speaker = "speaker"
        case createdAt = "created_at"
    }
}

// MARK: - Speaker
public struct Speaker: Codable {
    public let id: String?
    public let name: String?
    public let username: String?
    public let userID: String?
    public let anonymous: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case username = "username"
        case userID = "userId"
        case anonymous = "anonymous"
    }
}
