//
//  Environment.swift
//

import Foundation

public enum MeetUpEnvironments {
    case dev
    case staging
    case prod
}


//meetUp - stage-meet.khulke.com
//Api - stage-livestream.khulke.com
//Media Server - stage-stream.khulke.com

// FOR LIVE STREAM API / SWAGGER
public enum Environments {
    case dev
    case staging
    case prod
    
    var baseURL:String{
        switch self {
        case .dev: return  "https://dev-livestream.khulke.com/v1/"
        case .staging: return  "https://stage-livestream.khulke.com/v1/"
        case .prod: return "https://livestream.khulke.com/v1/"
        }
    }
    
    var rtBaseURL:String {
        switch self {
            case .dev: return  "https://dev-rtgo.khulke.com/v1"
            case .staging: return  "https://stage-rtgo.khulke.com/v1"
            case .prod: return "https://rtgo.khulke.com/v1"
        }
    }
}

public class Environment {
    
    public var environment: Environments = .dev
    
}

// FOR LIVE KIT
public enum LKEnvironments {
    case dev
    case staging
    case prod
    
    var baseURL:String{
        switch self {
        case .dev: return  "wss://dev-stream.khulke.com"
        case .staging: return  "wss://stage-stream.khulke.com"
        case .prod: return "wss://stream.khulke.com"
        }
    }
}

public class LKEnvironment {
    
    public var environment: LKEnvironments = .dev
    
}


// FOR SERVER CALLING API AND ROOMS
public enum ServerEnvironments {
    case dev
    case staging
    case prod
    
    var baseURL:String{
        switch self {
        case .dev: return  "https://dev-meet.khulke.com/"
        case .staging: return  "https://stage-meet.khulke.com/"
        case .prod: return "https://meet.khulke.com/"
        }
    }
}


public class ServerEnvironment {
    
    public var environment: ServerEnvironments = .dev
    
}


// FOR GET IMAGE URL FROM SERVER
public enum ImageEnvironments {
    case dev
    case staging
    case prod
}

public class ImageURL {
    
    class func getUserImage(name: String, env : ImageEnvironments) -> String{
        switch env {
        case .dev:
            return "https://dev.useronboarding.khulke.com/user/profile-photo/\(name)/medium/"
        case .staging:
            return "https://stage.useronboarding.khulke.com/user/profile-photo/\(name)/medium/"
        case .prod:
            return "https://useronboarding.khulke.com/user/profile-photo/\(name)/medium/"
        }
    }
}

