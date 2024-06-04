//
//  PostMessageModel .swift
//  LoktantramMeetup
//
//  Created by Loktantram on 20/07/23.
//

import Foundation



// MARK: - PostMessageModel
public struct NoDataModel: Codable {
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}
