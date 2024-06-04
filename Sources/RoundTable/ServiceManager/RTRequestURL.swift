//
//  RTRequestURL.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 16/10/23.
//

import Foundation

public enum RTRequestURL {
    case getAuthToken
    case getRTToken(rtId: String)
    case leaveRT(rtId: String)
    case selfRemove(rtId: String)
    case endRT(rtId: String)
    case extendRT(rtId: String, time: Int)
    case toggleMic(rtId: String, userId: String)
    case muteAudience(rtId: String, userId: String)
    case getSingleRT(rtURL: URL, header: [String: String])
    case removeWildCardPanelist(rtId: String, userId: String)
    case addWildCardPanelist(rtId: String, userId: String)
    // New API Call
    case healthCheck
    case rtLikeDislikeAction(roundtable_id: String, action: String)
    case getRoundTables
    case getRTPostData(rtID: String, limit: Int, skip: Int)
    case getMutedAudience(rtId: String)
    case getWildcardUsers(rtId: String)
    case wildcardRequestAction(rtId: String, action: WildcardPanelistRequestAction)
    /*
     case postTextMessage(rt_id: String,
     text: String,
     type: String,
     lang: String,
     hashTags: [String],
     keywords : [String],
     topics:[String],
     parent_post_id: Int)
     */
    case postTextMessage(rt_id: String,
                         text: String,
                         type: String,
                         lang: String)
    case getPostDetails
    case rtUploadImages(rt_id: String,
                        type: String,
                        text: String,
                        file_details: [[String: Any]])
    case rtUploadDocument(rt_id: String,
                          type: String,
                          text: String,
                          file_details: [[String: Any]])
    case checkMimeType(rt_id: String, post_id: String, file_name: String)
    case postActions(roundtableId: String, action: RTActions, postId: String)
    case voteOnPollActions(roundtableId: String, action: RTActions, postId: String, pollOption: Int)
    case createRoundtable(name : String, moderator_id: Int)
    case endRoundtable(name : String, moderator_id: Int)
    case rtPaginate(type: String, limit: Int, skip: Int)
    case searchuser(search_term: String, limit: Int, offset: Int)
    case rtCreatePoll(params: [String: Any])
    case postPanelistMessage(rt_id: String, text: String)
    case getPanelistMessageByRt(rt_id:String, limit: Int, skip: Int)
    case postAudienceChat(rtId: String, text: String)
    case getAudienceChatByRt(rtId:String, userId:String, limit: Int, skip: Int)
    case deleteAudienceChatByRt(rtId:String, userId:String? = nil, chatId:String? = nil)
    case audienceRaiseHand(rtId:String)
    case getRaiseHandUserList(rtId:String, limit: Int, skip: Int)
    case deletePost(rtId: String, postId: String)
    case getStarredPost(rtID: String)
    case getWildcardPost(rtID: String)
    case commentWithTextMessage(rtId: String,
                               text: String,
                               type: String,
                               parrentPostID: String,
                               lang: String)
    case commentWithImageFiles(rtID: String,
                               type: String,
                               text: String,
                               parentPostID: String,
                               file_details: [[String: Any]])
    case commentWithDocFiles(rtID: String,
                             type: String,
                             text: String,
                             parentPostID: String,
                             file_details: [[String: Any]])
    case raiseHandWithMultiMediaFiles(rtID: String,
                               type: String,
                               text: String,
                               file_details: [[String: Any]])
    case checkMimeTypeForRaiseHand(rtId: String,
                                   postId: String,
                                   fileName: String,
                                   type: String)

    
    private var baseURL: String {
        return GlobalConfig.environment.rtBaseURL
    }
    
    var method: RTHTTPMethod {
        switch self {
            case .getAuthToken: return .post
            case .getRTToken: return .post
            case .getSingleRT: return .get
            case .healthCheck: return .get
            case .rtLikeDislikeAction: return .post
            case .getRoundTables: return .get
            case .getRTPostData: return .get
            case .postTextMessage: return .post
            case .getPostDetails: return .get
            case .rtUploadImages: return .post
            case .rtUploadDocument: return .post
            case .checkMimeType: return .post
            case .postActions: return .post
            case .createRoundtable: return .post
            case .endRoundtable: return .post
            case .rtPaginate: return .post
            case .searchuser: return .post
            case .leaveRT: return .delete
            case .endRT: return .delete
            case .extendRT: return .post
            case .toggleMic: return .post
            case .rtCreatePoll: return .post
            case .postPanelistMessage: return .post
            case .getPanelistMessageByRt: return .get
            case .postAudienceChat: return .post
            case .getAudienceChatByRt: return .get
            case .deleteAudienceChatByRt: return .delete
            case .audienceRaiseHand: return .post
            case .getRaiseHandUserList: return .get
            case .voteOnPollActions: return .post
            case .removeWildCardPanelist: return .post
            case .addWildCardPanelist: return .post
            case .getMutedAudience: return .get
            case .muteAudience: return .post
            case .deletePost: return .post
            case .wildcardRequestAction: return .post
            case .getStarredPost: return .get
            case .getWildcardPost: return .get
            case .selfRemove: return .post
            case .commentWithTextMessage: return .post
            case .commentWithImageFiles: return .post
            case .commentWithDocFiles: return .post
            case .raiseHandWithMultiMediaFiles: return .post
            case .checkMimeTypeForRaiseHand: return .post
            case .getWildcardUsers: return .get
        }
    }
    var headers: [String: String]? {
        switch self {
            case .getAuthToken:
                return ["Authorization": "Bearer \(GlobalConfig.accessToken)"]
            case .getRTToken(rtId: _):
                return [
                    "Authorization": "Bearer \(GlobalConfig.rtAccessToken)",
                    "X-Platform": "IOS",
                    "X-Orientation": "PORTRAIT"
                ]
            case .getSingleRT(rtURL: _ , header: let header): return header
            default:
                return ["Authorization": "Bearer \(GlobalConfig.rtAccessToken)"]
                
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
            case .getAuthToken: return nil
            case .selfRemove(rtId: let rtId): return ["roundtable_id": rtId]
            case .getRTToken(rtId: let rtId): return ["roomId": rtId]
            case .getSingleRT: return nil
            case .healthCheck: return nil
            case .rtLikeDislikeAction(roundtable_id:  let rtId, action:  let rtAction):
                return ["roundtable_id": rtId,
                        "action": rtAction]
            case .getRoundTables: return nil
            case .getRTPostData: return nil
                /*case .postTextMessage(rt_id: let rt_id, text: let text, type: let type, lang: let lang, hashTags: let hashTags, keywords: let keywords, topics: let topics, parent_post_id: let parent_post_id):
                 return ["rt_id": rt_id,
                 "text": text,
                 "type": type,
                 "lang": lang,
                 "hashTags": hashTags,
                 "keywords": keywords,
                 "topics": topics,
                 "parent_post_id": parent_post_id]
                 */
            case .postTextMessage(rt_id: let rt_id, text: let text, type: let type, lang: let lang):
                return ["rt_id": rt_id,
                        "text": text,
                        "type": type,
                        "lang": lang]
            case .getPostDetails: return nil
            case .rtUploadImages(rt_id: let rt_id, type: let type, text: let text, file_details: let file_details):
                return ["rt_id": rt_id,
                        "text": text,
                        "type": type,
                        "file_details": file_details]
            case .rtUploadDocument(rt_id: let rt_id, type: let type, text: let text, file_details: let file_details):
                return ["rt_id": rt_id,
                        "text": text,
                        "type": type,
                        "file_details": file_details]
            case .checkMimeType(rt_id: let rt_id,
                                post_id: let post_id,
                                file_name: let file_name):
                return ["rt_id": rt_id,
                        "post_id": post_id,
                        "file_name": file_name]
            case .postActions(roundtableId: let roundtableId,
                              action: let action,
                              postId: let postId):
                return ["roundtable_id": roundtableId,
                        "action": action.rawValue,
                        "post_id": postId]
            case .createRoundtable(name: let name, moderator_id: let moderator_id):
                return ["name": name,
                        "moderator_id": moderator_id]
            case .endRoundtable(name: let name, moderator_id: let moderator_id):
                return ["name": name,
                        "moderator_id": moderator_id]
            case .rtPaginate(type: let type, limit: let limit, skip: let skip):
                return ["type": type,
                        "limit": limit,
                        "skip": skip]
            case .searchuser(search_term: let search_term, limit: let limit, offset: let offset):
                return ["search_term": search_term,
                        "limit": limit,
                        "offset": offset]
            case .leaveRT(rtId: let rtId): return ["roomId": rtId]
            case .endRT: return nil
            case .extendRT(rtId: let rtId, time: let time):
                return ["roundtable_id": rtId,
                        "end_time": time]
            case .toggleMic(rtId: let rtId, userId: let userId):
                return ["rt_id": rtId,
                        "user_id": userId]
            case .rtCreatePoll(params: let params): return params
            case .postPanelistMessage(rt_id: let rt_id, text: let text):
                return ["roundtable_id": rt_id,
                        "text": text]
            case .getPanelistMessageByRt(rt_id: let rt_id, limit: let limit, skip: let skip):
                return ["rt_id": rt_id,
                        "limit": limit,
                        "skip": skip]
            case .removeWildCardPanelist(rtId: let rtId, userId: let userId):
                return ["roundtable_id": rtId,
                        "wildcard_userid": userId]
            case .addWildCardPanelist(rtId: let rtId, userId: let userId):
                return ["roundtable_id": rtId,
                        "wildcard_userid": userId]
            case .getMutedAudience: return nil
            case .muteAudience(rtId: let rtId, userId: let userId):
                return ["roundtable_id": rtId,
                        "user_id": userId]
            case .voteOnPollActions(roundtableId: let roundtableId, action: let action, postId: let postId, pollOption: let pollOption):
                return ["roundtable_id": roundtableId,
                        "action": action.rawValue,
                        "post_id": postId,
                        "poll_option": pollOption
                ]
            case .deletePost: return nil
            case .wildcardRequestAction(rtId: let rtId, action: let action):
                return [ "roundtable_id": rtId,
                         "action": action.rawValue
                ]
            case .getStarredPost: return nil
            case .getWildcardPost: return nil
            case .postAudienceChat(rtId: let rtId, text: let text):
                return ["roundtable_id": rtId,
                        "text": text]
            case .getAudienceChatByRt(rtId: let rtId, userId: let userId, limit: let limit, skip: let skip):
                return ["rt_id": rtId,
                        "user_id": userId,
                        "limit": limit,
                        "skip": skip]
            case .deleteAudienceChatByRt(rtId: _, userId: _, chatId: _):
                return nil
            case .audienceRaiseHand(rtId: _):
                return nil
            case .getRaiseHandUserList(rtId: let rt_id, limit: let limit, skip: let skip):
                return ["rt_id": rt_id,
                        "limit": limit,
                        "skip": skip]
        case .commentWithTextMessage(rtId: let rtId, text: let text, type: let type, parrentPostID: let parrentPostID, lang: let lang):
            if type == "QUOTE" {
                return ["rt_id": rtId,
                        "text": text,
                        "type": type,
                        "parent_post_id": parrentPostID]
            }
            return ["rt_id": rtId,
                    "text": text,
                    "type": type,
                    "parent_post_id": parrentPostID,
                    "lang": lang]
        case .commentWithImageFiles(rtID: let rtID, type: let type, text: let text, parentPostID: let parentPostID, file_details: let file_details):
            return ["rt_id": rtID,
                    "text": text,
                    "type": type,
                    "parent_post_id": parentPostID,
                    "file_details": file_details]
        case .commentWithDocFiles(rtID: let rtID, type: let type, text: let text, parentPostID: let parentPostID, file_details: let file_details):
            return ["rt_id": rtID,
                    "text": text,
                    "type": type,
                    "parent_post_id": parentPostID,
                    "file_details": file_details]
        case .raiseHandWithMultiMediaFiles(rtID: let rtID, type: let type, text: let text, file_details: let file_details):
            return ["rt_id": rtID,
                    "text": text,
                    "type": type,
                    "file_details": file_details]
        case .checkMimeTypeForRaiseHand(rtId: let rtId, postId: let postId, fileName: let fileName, type: let type):
            return ["rt_id": rtId,
                    "post_id": postId,
                    "file_name": fileName,
                    "type": type]
            case .getWildcardUsers: return nil
        }
    }
    
    public func makeRequest<T: Codable>() -> RTAPIRequest<T> {
        return RTAPIRequest(url: self.url, method: self.method, headers: self.headers, parameters: self.parameters)
    }
    
    public var url: URL {
        switch self {
        case .getSingleRT(rtURL: let url, header: _): return url
        default: return URL(string: baseURL + path)!
        }
    }
    
    public var path: String {
        switch self {
            case .getAuthToken: return "/auth/init"
            case .getRTToken: return "/roundtable/participant"
            case .getSingleRT: return ""
            case .healthCheck: return "/healthcheck"
            case .rtLikeDislikeAction: return "/roundtable/rt-action"
            case .getRoundTables: return "/roundtable"
            case .getRTPostData(rtID: let rtID, limit: let limit, skip: let skip):
                return "/roundtable/post?rt_id=\(rtID)&limit=\(limit)&skip=\(skip)"
            case .postTextMessage: return "/roundtable/post"
            case .getPostDetails: return "/roundtable/post/details"
            case .rtUploadImages: return "/roundtable/post/upload/rt-image"
        case .rtUploadDocument: return "/roundtable/post/upload/rt-docs"
            case .checkMimeType: return "/roundtable/post/media/uploaded"
            case .postActions: return "/roundtable/post/post-action"
            case .voteOnPollActions: return "/roundtable/post/post-action"
            case .createRoundtable: return "/roundtable"
            case .rtPaginate: return "/roundtable/paginate"
            case .endRoundtable: return "/roundtable"
            case .searchuser: return "/roundtable/search_user"
            case .leaveRT: return "/roundtable/participant"
            case .endRT(rtId: let rtId): return "/roundtable/\( rtId )"
            case .extendRT: return "/roundtable/extend-rt"
            case .toggleMic: return "/roundtable/toggle-mic"
            case .rtCreatePoll: return "/roundtable/post"
            case .postPanelistMessage: return "/roundtable/panelist-message"
            case .getPanelistMessageByRt: return "/roundtable/panelist-chat"
            case .postAudienceChat: return "/roundtable/audience-chat"
            case .getAudienceChatByRt: return "/roundtable/audience-chat"
            case .removeWildCardPanelist: return "/roundtable/remove-wildcard"
            case .addWildCardPanelist: return "/roundtable/add-wildcard"
            case .getMutedAudience(rtId: let rtId): return "/roundtable/post/muted-post?rt_id=\(rtId)"
            case .muteAudience: return "/roundtable/post/post-restriction"
        case .deletePost(rtId: let rtId, postId: let postId): return "/roundtable/post/post-delete?post_id=\(postId)&rt_id=\(rtId)"
            case .wildcardRequestAction: return "/roundtable/accept-wildcard-request/"
            case .getStarredPost(rtID: let rtID): return "/roundtable/post/starred-post?rt_id=\(rtID)"
            case .getWildcardPost(rtID: let rtID): return "/roundtable/post/wildcard-post?rt_id=\(rtID)"
            case .deleteAudienceChatByRt(rtId: let rtId, userId: let userId, chatId: let chatId ): return "/roundtable/dismiss-rh-chat?rt_id=\( rtId )&user_id=\(userId ?? "")&chat_id=\(chatId ?? "")"
            case .audienceRaiseHand(rtId: let rtId): return "/roundtable/raise-hand?rt_id=\( rtId )"
            case .getRaiseHandUserList: return "/roundtable/raise-hand"
            case .selfRemove: return "/roundtable/remove-wildcard"
        case .commentWithTextMessage(rtId: _, text: _, type: let type, parrentPostID: _, lang: _):
            if type == "QUOTE" {
                return "/roundtable/post/upload/rt-text"
            }
            return "/roundtable/post"
            case .commentWithImageFiles: return "/roundtable/post/upload/rt-image"
            case .commentWithDocFiles: return "/roundtable/post/upload/rt-docs"
        case .raiseHandWithMultiMediaFiles: return "/roundtable/post/upload/raise-hand"
        case .checkMimeTypeForRaiseHand: return "/roundtable/post/media/uploaded"
            case .getWildcardUsers(rtId: let rtId): return "/roundtable/wc-users?rt_id=\( rtId )"
        }
    }
}

public struct RTAPIRequest<T: Codable> {
    let url: URL
    let method: RTHTTPMethod
    let headers: [String: String]?
    let parameters: [String: Any]?
}
