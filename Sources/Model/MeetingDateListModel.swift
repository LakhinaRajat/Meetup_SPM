//
//  File.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 19/02/24.
//

import Foundation

public struct MeetingDateListModel: Codable {
    public let message: String?
    public let data: [String: Int]?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}
