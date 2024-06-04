//
//  Configuration.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 01/07/23.
//

import UIKit

public enum GlobalConfig {
    
    public static var meetUpEnvironment : MeetUpEnvironments = .dev {
        didSet {
            
            switch meetUpEnvironment {
            case .dev:
                environment = .dev
                lkEnvironment = .dev
                serverEnvironment = .dev

            case .staging:
                environment = .staging
                lkEnvironment = .staging
                serverEnvironment = .staging
                
            case .prod:
                environment = .prod
                lkEnvironment = .prod
                serverEnvironment = .prod
            }
        }
    }
        
    public static var environment : Environments = .dev {
        didSet {
            Environment().environment = environment
        }
    }
    
    public static var lkEnvironment : LKEnvironments = .dev {
        didSet {
            LKEnvironment().environment = lkEnvironment
        }
    }
    
    public static var serverEnvironment : ServerEnvironments = .dev {
        didSet {
            ServerEnvironment().environment = serverEnvironment
        }
    }
    
    public static var accessToken : String = ""
    public static var rtAccessToken: String = ""
    public static var liveKitToken : String = ""
    public static var meetingName : String = ""
    public static var getServerEnvironment : String = GlobalConfig.serverEnvironment.baseURL
    public static var appCtx : AppContext = AppContext(store: sync)
    public static var localPartcipantName : String = ""
    public static var localPartcipantUsername : String = ""
    public static var lastRemoteParticipantCount : Int = 0
    public static var useBroadcastExtension : Bool = false
    
    public static var isLoginInitialise : Bool = false
    
    // VAPT
    public static var encryptAccessToken : String = ""
    public static var sessionToken : String = ""


}

