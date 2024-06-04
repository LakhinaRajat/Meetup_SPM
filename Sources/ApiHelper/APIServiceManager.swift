//
//  RoomController.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 29/06/23.


import Foundation
import Alamofire
import UIKit

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject,
                                                     options: [.prettyPrinted]),
              let prettyJSON = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        
        return prettyJSON
    }
}

//MARK: - MultipartModel

public enum MultipartFileType : String {
    case image
    case video
    case doc
}

public struct MultipartModel {
    public let fileName: String
    public let image: UIImage?
    public let fileData: Data?
    public let fileURL: URL?
    public let fileType : MultipartFileType
    
    public init(fileName: String, image: UIImage? = nil, fileData: Data? = nil, fileURL: URL? = nil, fileType: MultipartFileType) {
        self.fileName = fileName
        self.image = image
        self.fileData = fileData
        self.fileURL = fileURL
        self.fileType = fileType
    }
}


public class APIServiceManager: NSObject {
    
    static let noInternetDictionary = ["message": "The Internet connection appears to be offline."]
    
    static func errorCondition(error : Error) -> NSDictionary {
        
        switch error._code {
        case -1001:
            var result = [String: String]()
            result["status"] = "1001"
            result["response"] = "server connection time out"
            return(result as NSDictionary)
        case -1004:
            var result = [String: String]()
            result["status"] = "1004"
            result["response"] = "server connection failed"
            return(result as NSDictionary)
        case -1005:
            var result = [String: String]()
            result["status"] = "1005"
            result["response"] = "The network connection was lost"
            return(result as NSDictionary)
        case -1009:
            var result = [String: String]()
            result["status"] = "1009"
            result["response"] = "The Internet connection appears to be offline."
            return(result as NSDictionary)
        default:
            var result = [String: String]()
            result["status"] = "0007"
            result["response"] = "Server not responding, please try again."
            return(result as NSDictionary)
        }
    }
    
    class func CallService(apiRoute: APIRouter, parameters: [String: Any] = [:], completion:@escaping ([String: Any]?,Int) -> Void) {
        
        guard (!NetworkReachability().isNetworkAvailable()) else {
            completion(noInternetDictionary, 1009)
            return
        }
        
        let routerStructure = APIRouterStructure(apiRouter: apiRoute)
        
        if(apiRoute.path != "logger/client-logs"){
            print("***************************************************************")
            print("Header -> Authorization:\("Bearer \(GlobalConfig.sessionToken)")")
            print("URL -> \(routerStructure.urlRequest?.url?.absoluteString ?? "")")
            print("http Method -> \(routerStructure.urlRequest?.httpMethod ?? "")")
//            print("routerStructure -> \(routerStructure)")
            print("***************************************************************")
        }
        
        AF.request(routerStructure).onURLSessionTaskCreation(perform: { (task) in
            //self.currentURLSession[router] = task
        }).responseData{
            response in
            
            switch response.result {
            case .success(let result):
                
                DispatchQueue.main.async {
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: result)
                        // print(asJSON)
                        if asJSON as? [String: Any] != nil {
                            completion((asJSON as! [String : Any]), response.response?.statusCode ?? 200)
                        }
                    } catch {
                        print("Error while decoding response from: \(String(data: result, encoding: .utf8) ?? "")")
                    }
                }
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion(APIServiceManager.errorCondition(error: error) as? [String : Any], response.response?.statusCode ?? 0)
                }
            }
        }
    }
    
    
    class func callhMultipartService(url: String, param : [String : Any], files: [MultipartModel], method: HTTPMethod, completion:@escaping ([String: Any]?,Int) -> Void)  {
        
        guard (!NetworkReachability().isNetworkAvailable()) else {
            completion(noInternetDictionary, 1009)
            return
        }
        
        let apiURL = URL(string: url)!
        
        // Alamofire upload request
        AF.upload(multipartFormData: { multipartFormData in
            
            // Append file to multipart form data
            for file in files {
                
                switch file.fileType {
                case .image:
                    
                    guard let logo = file.image else {
                        continue
                    }
                    
                    let imageData = logo.jpegData(compressionQuality: 1.0)
                    let name = file.fileName
                    multipartFormData.append(imageData!, withName: name, fileName: "\(name).png", mimeType: "image/png")
                    
                case .video:
                    
                    let name = file.fileName
                    if let url = file.fileURL {
                        let extention = url.pathExtension
                        let timestamp = Constants.getTimeWithMilisec
                        multipartFormData.append(url, withName: name, fileName: "\(timestamp).\(extention)", mimeType: "video/mp4")
                    }
                    
                case .doc:
                    
                    let name = file.fileName
                    if let url = file.fileURL {
                        let extention = url.pathExtension
                        let timestamp = Constants.getTimeWithMilisec
                        let imageData = file.fileData
                        var mimeType = ""
                        switch extention.lowercased() {
                        case "pdf":
                            mimeType = "application/pdf"
                        case "doc", "docx":
                            mimeType = "application/msword"
                        case "ppt", "pptx":
                            mimeType = "application/vnd.ms-powerpoint"
                        case "xls", "xlsx":
                            mimeType = "application/vnd.ms-excel"
                        default:
                            mimeType = ""
                        }
                        multipartFormData.append(imageData!, withName: name, fileName: "\(timestamp).\(extention)", mimeType: mimeType)
                    }
                }
            }
            
            // Append other parameters if any
            for (key, value) in param {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        },
                  to: apiURL,
                  method: method,
                  headers: HTTPHeaders(["Authorization": "Bearer \(GlobalConfig.sessionToken)"])
        )
        
        .response { response in
            // Handle response
            debugPrint(response)
            
            switch response.result {
            case .success(let result):
                
                DispatchQueue.main.async {
                    if let responseResult = result {
                        do {
                            let asJSON = try JSONSerialization.jsonObject(with: responseResult)
                            // print(asJSON)
                            if asJSON as? [String: Any] != nil {
                                completion((asJSON as! [String : Any]), response.response?.statusCode ?? 200)
                            }
                        } catch {
                            print("Error while decoding response from: \(String(data: responseResult, encoding: .utf8) ?? "")")
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion(APIServiceManager.errorCondition(error: error) as? [String : Any], response.response?.statusCode ?? 0)
                }
            }
        }
    }
}

