//
//  NetworkClient.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 16/10/23.
//

import Foundation
import Alamofire

public class NetworkClient {
    
    public static let shared: NetworkClient = NetworkClient()
    
    private init() {}
    
    public func getAuthToken(completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getAuthToken.makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func getWildcardUsersList(from rtId: String, completion: @escaping (Result<APIResponse<WildcardDataModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getWildcardUsers(rtId: rtId).makeRequest() as RTAPIRequest<WildcardDataModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func removeSelfUser(from rtId: String, completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.selfRemove(rtId: rtId).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func removeWildcardPanelist(with rtId: String, userId: String,completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.removeWildCardPanelist(rtId: rtId, userId: userId).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func addWildcardPanelist(with rtId: String, userId: String,completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.addWildCardPanelist(rtId: rtId, userId: userId).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func toggleAudience(with rtId: String, userId: String,completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.muteAudience(rtId: rtId, userId: userId).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func getMutedAudience(with rtId: String,completion: @escaping (Result<APIResponse<MutedAudienceModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getMutedAudience(rtId: rtId).makeRequest() as RTAPIRequest<MutedAudienceModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func toggleUserMic(with rtId: String, userId: String, completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.toggleMic(rtId: rtId, userId: userId).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func createPollOnRT(with params: [String: Any], apiToken: String, completion: @escaping (Result<APIResponse<RTPollModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.rtCreatePoll(params: params).makeRequest() as RTAPIRequest<RTPollModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func endRT(with rtId: String, completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.endRT(rtId: rtId).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func extendRT(with rtId: String, time: Int, completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.extendRT(rtId: rtId, time: time).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func getRTToken(with rtId: String, completion: @escaping (Result<APIResponse<RTJoiningTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getRTToken(rtId: rtId).makeRequest() as RTAPIRequest<RTJoiningTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
   /*
    public func getSingleRT(with url: URL, header: [String: String], completion: @escaping (Result<APIResponse<RTResponseDataModel>, Error>) -> Void) {
        let request =  RTRequestURL.getSingleRT(rtURL: url, header: header).makeRequest() as RTAPIRequest<RTResponseDataModel>
        RTServiceManager.shared.request(request) { result in
            completion(result)
        }
    }
    */
    public func getHealthCheck(completion: @escaping (Result<APIResponse<HealthCheckModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.healthCheck.makeRequest() as RTAPIRequest<HealthCheckModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func doLikeDislikeRTActions(with rtId: String, action: String, completion: @escaping (Result<APIResponse<RTLikeDislikeModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.rtLikeDislikeAction(roundtable_id: rtId, action: action).makeRequest() as RTAPIRequest<RTLikeDislikeModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func getRoundTables(completion: @escaping (Result<APIResponse<RoundTableModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getRoundTables.makeRequest() as RTAPIRequest<RoundTableModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK: get rt post data
    public func getRTPostData(rtID: String, limit: Int, skip: Int, completion: @escaping (Result<APIResponse<GoPostDataModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getRTPostData(rtID: rtID, limit: limit, skip: skip).makeRequest() as RTAPIRequest<GoPostDataModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    /*
    public func postTextMessage(with rt_id: String, text: String, type: String, lang: String, hashTags: [String], keywords : [String], topics:[String], parent_post_id: Int, completion: @escaping (Result<APIResponse<RTPostsModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.postTextMessage(rt_id: rt_id, text: text, type: type, lang: lang, hashTags: hashTags, keywords: keywords, topics: topics, parent_post_id: parent_post_id).makeRequest() as RTAPIRequest<RTPostsModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    */
    
    public func postTextMessage(with rtId: String, text: String, type: String, lang: String, completion: @escaping (Result<APIResponse<PostTextMessageResponseModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.postTextMessage(rt_id: rtId, text: text, type: type, lang: lang).makeRequest() as RTAPIRequest<PostTextMessageResponseModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func getPostDetails(completion: @escaping (Result<APIResponse<RTPostsModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getPostDetails.makeRequest() as RTAPIRequest<RTPostsModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func postRTImages(rt_id: String, type: String, text: String, file_details: [[String: Any]], files: [MultiMediaAttachmentFile], completion: @escaping (Result<APIResponse<UploadMediaResponseModel>, Error>) -> Void) {
        var authRequest = RTRequestURL.rtUploadImages(rt_id: rt_id, type: type, text: text, file_details: file_details).makeRequest() as RTAPIRequest<UploadMediaResponseModel>
        if files.first?.fieldName != "image" {
            authRequest = RTRequestURL.rtUploadDocument(rt_id: rt_id, type: type, text: text, file_details: file_details).makeRequest() as RTAPIRequest<UploadMediaResponseModel>
        }
        RTServiceManager.shared.request(authRequest) { result in
            switch result {
            case .success(let resp):
                completion(result)
                files.forEach { mFile in
                    guard let dataR = resp.data?.data, let postID = dataR.postID, let presignUrls = dataR.presignUrls else { return }
                    guard let presignUrlString = presignUrls[mFile.md5Token], let presignUrl = URL(string: presignUrlString) else { return }
                    let authHeader = [/*"Authorization": "Bearer \(GlobalConfig.rtAccessToken)",*/ "Content-MD5": mFile.md5Token, "Content-Type": mFile.mimeType.rawValue ]
                    let authRequest = RTAPIRequest<RTPostsModel>(url: presignUrl, method: .put, headers: authHeader, parameters: nil)
                    RTServiceManager.shared.uploadMultiMediaAttachment(url: presignUrlString, file: mFile, headers: HTTPHeaders(authHeader)) { resp, statusCode in
                        if statusCode == 200 {
                            self.checkMimeType(rt_id: rt_id, post_id: postID, file_name: mFile.fileName) { resultC in
                                print("resultOfCheckMime: \(resultC)")
                            }
                        }
                    }
                }
            case .failure(let err):
                print("errPostRTImages: \(err)")
                completion(result)
            }
        }
    }
    
    public func checkMimeType(rt_id: String, post_id: String, file_name: String, completion: @escaping (Result<APIResponse<RTPostsModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.checkMimeType(rt_id: rt_id, post_id: post_id, file_name: file_name).makeRequest() as RTAPIRequest<RTPostsModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func postLikeDislikeAction(roundtableId: String, action: RTActions, postId: String, completion: @escaping (Result<APIResponse<RTActionModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.postActions(roundtableId: roundtableId, action: action, postId: postId).makeRequest() as RTAPIRequest<RTActionModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func postWildcardOrStaredAction(roundtableId: String, action: RTActions, postId: String, completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.postActions(roundtableId: roundtableId, action: action, postId: postId).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func postCirculateAction(roundtableId: String, postId: String, completion: @escaping (Result<APIResponse<RTActionModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.postActions(roundtableId: roundtableId, action: .circulate, postId: postId).makeRequest() as RTAPIRequest<RTActionModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func voteOnPollAction(roundtableId: String, postId: String, pollOption: Int, completion: @escaping (Result<APIResponse<PostTextMessageResponseModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.voteOnPollActions(roundtableId: roundtableId, action: .poll, postId: postId, pollOption: pollOption).makeRequest() as RTAPIRequest<PostTextMessageResponseModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func deletePost(roundtableId: String, postId: String, completion: @escaping (Result<APIResponse<AuthTokenModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.deletePost(rtId: roundtableId, postId: postId).makeRequest() as RTAPIRequest<AuthTokenModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func wildcardRequestAction(roundtableId: String, action: WildcardPanelistRequestAction, completion: @escaping (Result<APIResponse<WildcardPanelistRequestModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.wildcardRequestAction(rtId: roundtableId, action: action).makeRequest() as RTAPIRequest<WildcardPanelistRequestModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func createRoundtable(name: String, moderator_id: Int, completion: @escaping (Result<APIResponse<RTPostsModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.createRoundtable(name: name, moderator_id: moderator_id).makeRequest() as RTAPIRequest<RTPostsModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func endRoundtable(name: String, moderator_id: Int, completion: @escaping (Result<APIResponse<RTPostsModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.createRoundtable(name: name, moderator_id: moderator_id).makeRequest() as RTAPIRequest<RTPostsModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func rtPaginate(type: String, limit: Int, skip: Int, completion: @escaping (Result<APIResponse<RTPostsModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.rtPaginate(type: type, limit: limit, skip: skip).makeRequest() as RTAPIRequest<RTPostsModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func searchuser(search_term: String, limit: Int, offset: Int, completion: @escaping (Result<APIResponse<RTPostsModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.searchuser(search_term: search_term, limit: limit, offset: offset).makeRequest() as RTAPIRequest<RTPostsModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK:  API -> Post Panelist Message
    public func postPanelistMessage(rt_id: String, text: String, completion: @escaping (Result<APIResponse<RTPanelistMessageModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.postPanelistMessage(rt_id: rt_id, text: text).makeRequest() as RTAPIRequest<RTPanelistMessageModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK:  API -> Get Panelist Message History
    public func getPanelistMessageHistory(rt_id: String,limit: Int, skip: Int, completion: @escaping (Result<APIResponse<RTPanelistMessageListModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getPanelistMessageByRt(rt_id: rt_id, limit: limit, skip: skip).makeRequest() as RTAPIRequest<RTPanelistMessageListModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    public func postAudienceChat(rt_id: String, text: String, completion: @escaping (Result<APIResponse<RTAudienceChatModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.postAudienceChat(rtId: rt_id, text: text).makeRequest() as RTAPIRequest<RTAudienceChatModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK: get Starred Post Data
    public func getStarredPostData(rtID: String, completion: @escaping (Result<APIResponse<StarredAndWildcardPostDataModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getStarredPost(rtID: rtID).makeRequest() as RTAPIRequest<StarredAndWildcardPostDataModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK: get Wildcard Post Data
    public func getWildcardPostData(rtID: String, completion: @escaping (Result<APIResponse<StarredAndWildcardPostDataModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getWildcardPost(rtID: rtID).makeRequest() as RTAPIRequest<StarredAndWildcardPostDataModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK:  API -> Post Audience Chat
    public func postAudienceChat(rtId: String, text: String, completion: @escaping (Result<APIResponse<RTAudienceChatModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.postAudienceChat(rtId: rtId, text: text).makeRequest() as RTAPIRequest<RTAudienceChatModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK:  API -> Get Audience Message History
    public func getAudienceChatHistory(rtId: String, userId: String, limit: Int, skip: Int, completion: @escaping (Result<APIResponse<RTAudienceChatListModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getAudienceChatByRt(rtId: rtId, userId: userId , limit: limit, skip: skip).makeRequest() as RTAPIRequest<RTAudienceChatListModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK:  API -> Delete Audience Message
    public func deleteAudienceChat(rtId: String, userId: String? = nil, chatId: String? = nil, completion: @escaping (Result<APIResponse<NoDataModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.deleteAudienceChatByRt(rtId: rtId, userId: userId, chatId: chatId).makeRequest() as RTAPIRequest<NoDataModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }

    //MARK:  API -> Post Audience Raise Hand
    public func audienceRaiseHand(rtId: String, completion: @escaping (Result<APIResponse<NoDataModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.audienceRaiseHand(rtId: rtId).makeRequest() as RTAPIRequest<NoDataModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK:  API -> Get Raised Hand User List for Moderator / Owner
    public func getRaiseHandUserList(rtId: String, limit: Int, skip: Int, completion: @escaping (Result<APIResponse<RaisdHandUserListModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.getRaiseHandUserList(rtId: rtId, limit: limit, skip: skip).makeRequest() as RTAPIRequest<RaisdHandUserListModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK: comment with text message
    public func commentWithTextMessage(with rtId: String, text: String, type: String, parrentPostId: String, lang: String, completion: @escaping (Result<APIResponse<PostTextMessageResponseModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.commentWithTextMessage(rtId: rtId, text: text, type: type, parrentPostID: parrentPostId, lang: lang).makeRequest() as RTAPIRequest<PostTextMessageResponseModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }
    
    //MARK: comment with Multimedia files
    public func commentWithMultimediaFiles(rtID: String, type: String, text: String, parentPostID: String, file_details: [[String: Any]], files: [MultiMediaAttachmentFile], completion: @escaping (Result<APIResponse<UploadMediaResponseModel>, Error>) -> Void) {
        var authRequest = RTRequestURL.commentWithImageFiles(rtID: rtID, type: type, text: text, parentPostID: parentPostID, file_details: file_details).makeRequest() as RTAPIRequest<UploadMediaResponseModel>

        if files.first?.fieldName != "image" {
            var authRequest = RTRequestURL.commentWithDocFiles(rtID: rtID, type: type, text: text, parentPostID: parentPostID, file_details: file_details).makeRequest() as RTAPIRequest<UploadMediaResponseModel>
        }
        RTServiceManager.shared.request(authRequest) { result in
            switch result {
            case .success(let resp):
                completion(result)
                files.forEach { mFile in
                    guard let dataR = resp.data?.data, let postID = dataR.postID, let presignUrls = dataR.presignUrls else { return }
                    guard let presignUrlString = presignUrls[mFile.md5Token], let presignUrl = URL(string: presignUrlString) else { return }
                    let authHeader = ["Content-MD5": mFile.md5Token, "Content-Type": mFile.mimeType.rawValue ]
                    RTServiceManager.shared.uploadMultiMediaAttachment(url: presignUrlString, file: mFile, headers: HTTPHeaders(authHeader)) { resp, statusCode in
                        if statusCode == 200 {
                            self.checkMimeType(rt_id: rtID, post_id: postID, file_name: mFile.fileName) { resultC in
                                print("resultOfCheckMime: \(resultC)")
                            }
                        }
                    }
                }
            case .failure(let err):
                print("errPostRTImages: \(err)")
                completion(result)
            }
        }
    }
    
    //MARK: raise hand with Multimedia files
    public func raiseHandWithMultimediaFiles(rtID: String, type: String, text: String, file_details: [[String: Any]], files: [MultiMediaAttachmentFile], completion: @escaping (Result<APIResponse<UploadMediaResponseModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.raiseHandWithMultiMediaFiles(rtID: rtID, type: type, text: text, file_details: file_details).makeRequest() as RTAPIRequest<UploadMediaResponseModel>

        RTServiceManager.shared.request(authRequest) { result in
            switch result {
            case .success(let resp):
                completion(result)
                files.forEach { mFile in
                    guard let dataR = resp.data?.data, let postID = dataR.postID, let presignUrls = dataR.presignUrls else { return }
                    guard let presignUrlString = presignUrls[mFile.md5Token], let presignUrl = URL(string: presignUrlString) else { return }
                    let authHeader = ["Content-MD5": mFile.md5Token, "Content-Type": mFile.mimeType.rawValue ]
                    RTServiceManager.shared.uploadMultiMediaAttachment(url: presignUrlString, file: mFile, headers: HTTPHeaders(authHeader)) { resp, statusCode in
                        if statusCode == 200 {
                            self.checkMimeTypeForRaiseHand(rtId: rtID, postId: postID, fileName: mFile.fileName, type: type) { resultC in
                                print("resultOfRHCheckMime: \(resultC)")
                            }
                        }
                    }
                }
                
            case .failure(let err):
                print("errRHMultimedia: \(err)")
                completion(result)
            }
        }
    }
    
    public func checkMimeTypeForRaiseHand(rtId: String, postId: String, fileName: String, type: String, completion: @escaping (Result<APIResponse<RTPostsModel>, Error>) -> Void) {
        let authRequest = RTRequestURL.checkMimeTypeForRaiseHand(rtId: rtId, postId: postId, fileName: fileName, type: type).makeRequest() as RTAPIRequest<RTPostsModel>
        RTServiceManager.shared.request(authRequest) { result in
            completion(result)
        }
    }

}
