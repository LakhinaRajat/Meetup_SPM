//
//  ParticipantsModel.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 11/09/23.
//

import Foundation
import LiveKit

struct ParticipantModel: Identifiable {
    var id: String = "\(UUID())"
    var participant: Participant
    var canPublish: Bool
    var canSubscribe: Bool
    
    init(participant: Participant, canPublish: Bool? = nil, canSubscribe: Bool? = nil) {
        self.participant = participant
        
        if let publish = canPublish {
            self.canPublish = publish
        } else {
            self.canPublish = participant.permissions.canPublish
        }
        
        if let subscribe = canSubscribe {
            self.canSubscribe = subscribe
        } else {
            self.canSubscribe = participant.permissions.canSubscribe
        }
    }
}
