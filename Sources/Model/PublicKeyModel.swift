//
//  PublicKeyModel.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 11/04/24.
//

import Foundation

// MARK: - LoginModel
public struct PublicKeyModel: Codable {
    public let message: String?
    public let data: PublicKeyResponse?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
public struct PublicKeyResponse: Codable {
    public let publicKey: String?

    enum CodingKeys: String, CodingKey {
        case publicKey = "public_key"
    }
}
