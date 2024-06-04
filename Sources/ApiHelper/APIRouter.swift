//
//  APIRouter.swift
//
import Foundation
import Alamofire
import UIKit

typealias dictionary = [String:Any]

enum APIRouter {
    
    /** AUTH  **/
    case login(param:dictionary)
    case getProfile
    case createRoom(param:dictionary)
    case updateRoom(id:String, param:dictionary)
    case generateToken(id:String,param:dictionary)
    case getMessagesByMeetingId(id:String,param:dictionary)
    case postMessage(id:String,param:dictionary)
    case acceptUsersInMeeting(id:String,param:dictionary)
    case rejectUserFromMeeting(id:String,param:dictionary)
    case toggleRecording(id:String)
    case toggleTranscription(id:String)
    case muteUsers(id:String)
    case deleteRoom(id:String)
    case getAllFollowersFollowingList(param:dictionary)
    case getMeetings(param:dictionary)
    case postErrorLogs(param:dictionary)
    case getRoomDetailsByMeetingId(id:String,param:dictionary)
    case getTranscriptionByMeetingId(meetingId: String, transcriptionID: String,param:dictionary)
    case getMeetNotifcation(param:dictionary)
    case sendInviteStatus(param:dictionary)
    case getMeetingListMonthWise(param:dictionary)
    case getPublicKey
    case getSessionTokenFromLoginAPI

}

extension APIRouter{
    
    var defaultHeaders : [String : String] {
        var headers :  [String : String] = [:]
        // Add your custom header here
        headers["device_name"] = UIDevice.modelName
        headers["platform"] = "iOS"
        headers["country"] = "India"
        headers["ip_address"] = UIDevice.current.getIP() ?? "0.0.0.0"
        return headers
    }

    var baseURL:String{
        return GlobalConfig.environment.baseURL
    }
    
    var method:HTTPMethod{
        switch self{
            /** AUTH  **/
        case .login: return .post
        case .getProfile: return .get
        case .createRoom: return .post
        case .generateToken: return .post
        case .getMessagesByMeetingId: return .get
        case .postMessage: return .post
        case .deleteRoom: return .delete
        case .getAllFollowersFollowingList: return .post
        case .toggleRecording: return .get
        case .toggleTranscription: return .get
        case .muteUsers: return .post
        case .acceptUsersInMeeting: return .post
        case .rejectUserFromMeeting: return .post
        case .getMeetings: return .get
        case .updateRoom: return .patch
        case .postErrorLogs: return .post
        case .getRoomDetailsByMeetingId: return .get
        case .getTranscriptionByMeetingId: return .get
        case .getMeetNotifcation: return .get
        case .sendInviteStatus: return .put
        case .getMeetingListMonthWise: return .get
        case .getPublicKey: return .get
        case .getSessionTokenFromLoginAPI: return .get

        }
    }
    
    var isURLEncoded:Bool{
        switch self{
            /** AUTH  **/
        case .login: return true
        case .getProfile: return true
        case .createRoom: return true
        case .generateToken: return true
        case .getMessagesByMeetingId: return true
        case .postMessage: return true
        case .deleteRoom: return true
        case .getAllFollowersFollowingList: return true
        case .toggleRecording: return true
        case .toggleTranscription: return true
        case .muteUsers: return true
        case .acceptUsersInMeeting: return true
        case .rejectUserFromMeeting: return true
        case .getMeetings: return false
        case .updateRoom: return true
        case .postErrorLogs: return true
        case .getRoomDetailsByMeetingId: return true
        case .getTranscriptionByMeetingId: return true
        case .getMeetNotifcation: return true
        case .sendInviteStatus: return true
        case .getMeetingListMonthWise: return true
        case .getPublicKey: return true
        case .getSessionTokenFromLoginAPI: return true
        }
    }
    
    var path:String {
        switch self{
        case .login: return "user/login"
        case .getProfile: return "user"
        case .createRoom: return "room/create-room"
        case let .generateToken(id:id, _): return "room/\(id)/generate-token"
        case let .getMessagesByMeetingId(id:id, _): return "room/\(id)/message"
        case let .postMessage(id:id, _): return "room/\(id)/message"
        case let .deleteRoom(id:id): return "room/\(id)"
        case .getAllFollowersFollowingList: return "user/get-all-followers-following/"
        case .toggleRecording(id: let id): return "room/\(id)/toggle-recording"
        case .toggleTranscription(id: let id): return "room/\(id)/toggle-transcription"
        case .muteUsers(id: let id): return "room/\(id)/mute-users"
        case .acceptUsersInMeeting(id: let id, param: _): return "room/\(id)/accept"
        case .rejectUserFromMeeting(id: let id, param: _): return "room/\(id)/reject"
        case .getMeetings(param: _): return "room"
        case .updateRoom(id: let id, param: _): return "room/\(id)"
        case .postErrorLogs: return "logger/client-logs"
        case let .getRoomDetailsByMeetingId(id:id, _): return "room/\(id)/room-detail"
        case let .getTranscriptionByMeetingId(meetingId:meetingId, transcriptionID:transcriptionID, _): return "room/\(meetingId)/transcription/\(transcriptionID)"
        case .getMeetNotifcation(param: _): return "notifcation"
        case .sendInviteStatus(param: _): return "user/invite-status"
        case .getMeetingListMonthWise(param: _): return "room/rooms-count"
        case .getPublicKey: return "public-resource/publicKey"
        case .getSessionTokenFromLoginAPI: return "public-resource/login"

        }
    }
    
    var encoding:ParameterEncoding?{
        switch self {
        default:return URLEncoding.default
        }
    }
    
    var formEncoding:ParameterEncoder?{
        switch self {
        default:return nil
        }
    }
    
    var additionalHeaders: [String:String]? {
        switch self {
        default : return defaultHeaders
        }
    }
    
    var timeout: TimeInterval {
        switch self {
        default: return 20
        }
    }
    
    var parameters: Parameters? {
        switch self {
                /** AUTH  **/
            case let .login(param: param): return param
            case .getProfile: return nil
            case let .createRoom(param: param): return param
            case let .generateToken(_, param: param): return param
            case let .getMessagesByMeetingId(_, param: param): return param
            case let .postMessage(_, param: param): return param
            case .deleteRoom(_ ): return nil
            case let .getAllFollowersFollowingList(param: param): return param
            case .toggleRecording: return nil
            case .toggleTranscription: return nil
            case .muteUsers: return nil
            case .acceptUsersInMeeting(id: _, param: let param): return param
            case .rejectUserFromMeeting(id: _, param: let param): return param
            case .getMeetings(param: let param): return param
            case .updateRoom(id: _, param: let param): return param
            case .postErrorLogs(_ ): return nil
            case let .getRoomDetailsByMeetingId(_, param: param): return param
            case let .getTranscriptionByMeetingId(_, _, param: param): return param
            case .getMeetNotifcation(param: let param): return param
            case .sendInviteStatus(param: let param): return param
            case .getMeetingListMonthWise(param: let param): return param
            case .getPublicKey: return nil
            case .getSessionTokenFromLoginAPI: return nil
            
        }
    }
}

