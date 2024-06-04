//
//  MultiAttachmentModel.swift
//  LoktantramMeetup
//
//  Created by Kamlesh Nimradkar on 21/11/23.
//

import Foundation

// MARK: - UploadMediaResponseModel
public struct UploadMediaResponseModel: Codable {
    public let data: UploadMediaResponseData?
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case data
        case message
    }
}

// MARK:  DataR
public struct UploadMediaResponseData: Codable {
    public let postID: String?
    public let presignUrls: [String: String]?
    public let parentPostID: String?

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case presignUrls = "presign-urls"
        case parentPostID = "parent_post_id"
    }
}

