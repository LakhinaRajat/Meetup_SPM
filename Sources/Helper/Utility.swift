//
//  Utility.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 04/07/23.
//

import Foundation

class Utility: NSObject {
    
    // Convert JSON to DataModel.
    static public func jsonToCustomModel<T:Codable>(data:[String : Any], type:T.Type) -> T? {
        do {
             let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
             let decodedDict = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedDict
        } catch {
            print(error)
            
            let params: [String: Any] = ["type": "ERROR",
                                         "message": "typeMismatch",
                                         "details" : error.localizedDescription,
                                         "severity" : "HIGH",
                                         "platform" : "IOS" ]
            
            MeetAPIController.shared.sendErrorLogApi(params: params) { response, statusCode  in
                if(statusCode == 200){
                  // print("Error log successfully")
                } else {
                    print("Error log failed")
                }
            }
            
            return nil
        }
    }
    
    static func jsonSting(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
}
