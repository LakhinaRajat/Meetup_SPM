//
//  Constants.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 30/08/23.
//

import Foundation

struct Constants {
    static var getTimeWithMilisec: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

struct EventUtils {
    static let eventType = "type"
    static let eventValue = "value"
    static let typeMessage = "MESSAGE"
    static let messageBody = "message"
    static let messageTimestamp = "created_at"
    static let messageSender = "by"
    static let senderUsername = "username"
    static let senderName = "name"
    static let typeRecordingStart = "RECORDING_STARTED"
    static let typeRecordingStop = "RECORDING_ENDED"
    static let typeTranscriptionStart = "TRANSCRIPTION_STARTED"
    static let typeTranscriptionStop = "TRANSCRIPTION_ENDED"
    static let requestRejected = "REQUEST_REJECTED"
   
}
