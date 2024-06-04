//
//  RoomController.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 29/06/23.
//

import UIKit

public class MeetAPIController {
    
    public static let shared = MeetAPIController()
    
    private init() {
        
    }
    
    //MARK:  API -> Get User Detail
    public func getUserDetail(completion:@escaping (UserModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute: .getProfile,completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: UserModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
        
    }
    
    //MARK:  API -> Create Schedule Meeting
    public func createScheduleMeeting(params : [String:Any], completion:@escaping (MeetingModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.createRoom(param: params),completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: MeetingModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
        
    }
    
    //MARK:  API -> Update Meeting
    public func updateMeeting(meetingID: String, params : [String:Any], completion:@escaping (MeetingModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.updateRoom(id: meetingID, param: params),completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: MeetingModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
        
    }
    
    //MARK:  API -> Generate Meeting Token
    public func createMeetingToken(meetingID: String, params : [String:Any], completion:@escaping (JoinedMeetingModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.generateToken(id: meetingID, param: params),completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: JoinedMeetingModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Get All Messages By MeetingId
    public func getAllMessagesByMeetingId(meetingID: String, params : [String:Any], completion:@escaping (GetMessagesModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.getMessagesByMeetingId(id: meetingID, param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: GetMessagesModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Post New Messages
    public func postMessagesByMeetingId(meetingID: String, params : [String:Any], completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.postMessage(id: meetingID, param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Accept user or users in meeting
    public func acceptParticipantRequestToJoin(meetingID: String, params : [String:Any], completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.acceptUsersInMeeting(id: meetingID, param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> reject user from meeting
    public func rejectParticipantRequestToJoin(meetingID: String, params : [String:Any], completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.rejectUserFromMeeting(id: meetingID, param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> toggleRecording api
    public func toggleRecording(for meetingID: String, completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.toggleRecording(id: meetingID),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> toggleTranscription api
    public func toggleTranscription(for meetingID: String, completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.toggleTranscription(id: meetingID),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Mute All Users api
    public func muteAllUsers(for meetingID: String, completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.muteUsers(id: meetingID),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Delete Room.
    public func deleteRoomByMeetingID(meetingID: String, completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.deleteRoom(id: meetingID),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Get all followers following list
    public func getAllFollowersFollowingList(params : [String:Any], completion:@escaping (FollowUnfollowUserModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.getAllFollowersFollowingList( param: params),completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: FollowUnfollowUserModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Get all meeting list
    public func getAllMeetingList(params : [String:Any], completion:@escaping (CalendarModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.getMeetings(param: params),completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: CalendarModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Post error log on Server
    public func sendErrorLogApi(params : [String:Any], completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.postErrorLogs(param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Get room details By MeetingId
    public func getRoomDetailsByMeetingId(meetingID: String, params : [String:Any], completion:@escaping (MeetingDetailModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.getRoomDetailsByMeetingId(id: meetingID, param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: MeetingDetailModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Get All Transcription By MeetingId
    public func getAllTranscriptionByMeetingId(meetingID: String, transcriptionID: String, params : [String:Any], completion:@escaping (TranscriptionListModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.getTranscriptionByMeetingId(meetingId: meetingID, transcriptionID: transcriptionID, param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: TranscriptionListModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Get All Meet Notification
    public func getAllMeetNotification(params : [String:Any], completion:@escaping (MeetNotificationModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.getMeetNotifcation(param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: MeetNotificationModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Send Invite Status
    public func sendInviteStatusApi(params : [String:Any], completion:@escaping (NoDataModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute:.sendInviteStatus(param: params),completion: {response, statusCode in
            if let dict = response, let dataModel = Utility.jsonToCustomModel(data: dict, type: NoDataModel.self){
                completion(dataModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Meetings list month wise
    public func getMeetingDatesByMonth(params : [String:Any], completion:@escaping (MeetingDateListModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute: .getMeetingListMonthWise(param: params),completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: MeetingDateListModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Create Schedule Meeting with attachments
    public func createScheduleMeetingWithFiles(params : [String:Any], files: [MultipartModel], completion:@escaping (MeetingModel?,Int) -> Void){
        let url =  GlobalConfig.environment.baseURL + APIRouter.createRoom(param: params).path
        APIServiceManager.callhMultipartService(url: url, param: params, files: files, method: .post, completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: MeetingModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> update Schedule Meeting with attachments
    public func updateMeetingWithFiles(meetingID: String, params : [String:Any], files: [MultipartModel], completion:@escaping (MeetingModel?,Int) -> Void){
        let url =  GlobalConfig.environment.baseURL + APIRouter.updateRoom(id: meetingID, param: params).path
        APIServiceManager.callhMultipartService(url: url, param: params, files: files, method: .patch, completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: MeetingModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    
    //MARK:  API -> Get public key for VAPT implementation
    public func getPublicKey(completion:@escaping (PublicKeyModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute: .getPublicKey, completion: {response, statusCode in
            if let dict = response, let publicKeyModel = Utility.jsonToCustomModel(data: dict, type: PublicKeyModel.self){
                completion(publicKeyModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
    
    //MARK:  API -> Call login api for fetch session token
    public func getSessionTokenFromLoginAPI(completion:@escaping (LoginModel?,Int) -> Void){
        APIServiceManager.CallService(apiRoute: .getSessionTokenFromLoginAPI, completion: {response, statusCode in
            if let dict = response, let userModel = Utility.jsonToCustomModel(data: dict, type: LoginModel.self){
                completion(userModel, statusCode)
            } else {
                completion(nil, statusCode)
            }
        })
    }
}
