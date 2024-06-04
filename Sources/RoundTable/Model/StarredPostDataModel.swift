//
//  StarredPostDataModel.swift
//  LoktantramMeetup
//
//  Created by Kamlesh Nimradkar on 30/11/23.
//

import Foundation

// MARK: - GoPostDataModel
public struct StarredAndWildcardPostDataModel: Codable {
    public let data: [GoPost]?
    public let message: String?
}
