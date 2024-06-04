//
//  GoPostDataModel.swift
//  LoktantramMeetup
//
//  Created by Kamlesh Nimradkar on 25/11/23.
//

import Foundation

// MARK: - GoPostDataModel
public struct GoPostDataModel: Codable {
    public let data: GoPostData?
    public let message: String?
}

// MARK: - GoPostData
public struct GoPostData: Codable {
    public let countOfRows: Int?
    public let posts: [GoPost]?

    enum CodingKeys: String, CodingKey {
        case countOfRows = "count_of_rows"
        case posts
    }
}

// MARK: - Post
public class GoPost: Codable {
    public let circulateCount: Int?
    public let createdAt: String?
    public let deletedAt: String?
    public let dislikeCount: Int?
    public let id: String?
    public let nodePostID: String?
    public let isPollEnded: Bool?
    public let likeCount, likes: Int?
    public let mediaUrls: [String]?
    public let mediaType: String?
    public let moderatorPromoted: Bool?
    public let options: [String]?
    public let parentPost: GoPost?
    public let parentPostID: String?
    public let percentage: [String]?
    public let pollEnd: String?
    public let quoteCount, repost: Int?
    public let roundtableID: String?
    public let text: String?
    public let type: String?
    public let updatedAt: String?
    public let user: User?
    public let selfCirculate: Bool?
    public let selfDislike: Bool?
    public let selfLike: Bool?
    public let selfStarred: Bool?
    public let selfVoted: Bool?

    public let recentlyCirculated: RecentlyCirculated?
    public let totalcount: Int?
    public let commentCount: Int?
    public let isstarred: Bool?
    public let thumbnailUrl: [String]?
    public let previewUrl: PreviewURL?


    enum CodingKeys: String, CodingKey {
        case circulateCount = "circulate_count"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case dislikeCount = "dislike_count"
        case id
        case nodePostID = "node_post_id"
        case isPollEnded = "is_poll_ended"
        case likeCount = "like_count"
        case likes
        case mediaUrls = "media-urls"
        case mediaType = "media_type"
        case moderatorPromoted = "moderator_promoted"
        case options
        case parentPost = "parent_post"
        case parentPostID = "parent_post_id"
        case percentage
        case pollEnd = "poll_end"
        case quoteCount = "quote_count"
        case repost
        case roundtableID = "roundtable_id"
        case text, type
        case updatedAt = "updated_at"
        case user
        case selfCirculate = "self_circulate"
        case selfDislike = "self_dislike"
        case selfLike = "self_like"
        case selfStarred = "self_starred"
        case selfVoted = "self_voted"
        case recentlyCirculated = "recently_circulated"
        case totalcount
        case commentCount = "comment_count"
        case isstarred = "is_starred"
        case thumbnailUrl = "thumbnail_url"
        case previewUrl = "preview_url"
    }

    init(circulateCount: Int, createdAt: String, deletedAt: String?, dislikeCount: Int, id: String, isPollEnded: Bool, likeCount: Int, likes: Int, mediaUrls: [String]?, mediaType: String, moderatorPromoted: Bool, options: [String]?, parentPost: GoPost?, parentPostID: String?, percentage: [String]?, pollEnd: String, quoteCount: Int, repost: Int, roundtableID: String, text: String, type: String, updatedAt: String, user: User, selfCirculate: Bool?, selfDislike: Bool?, selfLike: Bool?, selfStarred: Bool?, recentlyCirculated: RecentlyCirculated?, totalcount: Int?, selfVoted: Bool?, nodePostID: String?, commentCount: Int?, isStarred: Bool?, thumbnailUrl: [String]?, previewUrl: PreviewURL? ) {
        self.circulateCount = circulateCount
        self.createdAt = createdAt
        self.deletedAt = deletedAt
        self.dislikeCount = dislikeCount
        self.id = id
        self.isPollEnded = isPollEnded
        self.likeCount = likeCount
        self.likes = likes
        self.mediaUrls = mediaUrls
        self.mediaType = mediaType
        self.moderatorPromoted = moderatorPromoted
        self.options = options
        self.parentPost = parentPost
        self.parentPostID = parentPostID
        self.percentage = percentage
        self.pollEnd = pollEnd
        self.quoteCount = quoteCount
        self.repost = repost
        self.roundtableID = roundtableID
        self.text = text
        self.type = type
        self.updatedAt = updatedAt
        self.user = user
        self.selfCirculate = selfCirculate
        self.selfDislike = selfDislike
        self.selfLike = selfLike
        self.selfStarred = selfStarred
        self.recentlyCirculated = recentlyCirculated
        self.totalcount = totalcount
        self.selfVoted = selfVoted
        self.nodePostID = nodePostID
        self.commentCount = commentCount
        self.isstarred = isStarred
        self.thumbnailUrl = thumbnailUrl
        self.previewUrl = previewUrl
    }
}

// MARK: - User
public struct User: Codable {
    public let userID, username, name, id: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username
        case name
        case id = "_id"
    }
}

// MARK: - RecentlyCirculated
public struct RecentlyCirculated: Codable {
    public let createdAt: String?
    public let username: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case username
    }
}

// MARK: - PreviewURL
public struct PreviewURL: Codable {
    public let other: [Other]?
    public var youtube : [Other]?

    enum CodingKeys: String, CodingKey {
        case other = "other"
        case youtube = "youtube"
    }
}

// MARK: - Other
public struct Other: Codable {
    public let completeURL: String?

    enum CodingKeys: String, CodingKey {
        case completeURL = "complete_url"
    }
}

