//
//  RTServiceManager.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 16/10/23.
//

import Foundation
import Alamofire

public enum RTHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public struct APIResponse<T: Codable> {
    public let data: T?
    public let error: Error?
    public let statusCode: Int?
}

public class RTServiceManager {
    public static let shared = RTServiceManager()
    private let reachabilityManager = NetworkReachabilityManager()
    
    private init() {}
    
    public func request<T: Codable>(_ request: RTAPIRequest<T>, completion: @escaping (Result<APIResponse<T>, Error>) -> Void) {
        guard reachabilityManager?.isReachable == true else {
            completion(.failure(NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)))
            return
        }
        debugPrint("RTAPIMethodRequest Request URL:", request.url)
        debugPrint("method", HTTPMethod(rawValue: request.method.rawValue))
        debugPrint("headers", HTTPHeaders(request.headers ?? [:]))
        debugPrint("parameters", request.parameters)
        AF.request(request.url, 
                   method: HTTPMethod(rawValue: request.method.rawValue),
                   parameters: request.parameters,
                   encoding: request.method == .get ? URLEncoding.default : JSONEncoding.default,
                   headers: HTTPHeaders(request.headers ?? [:]))
            .responseData { response in
                DispatchQueue.main.async {
                    switch response.result {
                        case .success(let data):
                            do {
                                let asJSON = try JSONSerialization.jsonObject(with: data)
                                print("responseData:", asJSON)
                                
                                let decodedData = try JSONDecoder().decode(T.self, from: data)
                                let apiResponse = APIResponse(data: decodedData, error: nil, statusCode: response.response?.statusCode)
                                completion(.success(apiResponse))
                            } catch {
                                completion(.failure(error))
                            }
                            
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
    }
    
    
    public func upload<T: Codable>(_ request: RTAPIRequest<T>, files: [MultiMediaAttachmentFile], completion: @escaping (Result<APIResponse<T>, Error>) -> Void) {
        
        guard reachabilityManager?.isReachable == true else {
            completion(.failure(NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)))
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in request.parameters ?? [:] {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }
            for file in files {
                multipartFormData.append(file.data, withName: file.fieldName, fileName: file.fileName, mimeType: file.mimeType.rawValue)
            }
        }, to: request.url, usingThreshold: UInt64(), method: HTTPMethod(rawValue: request.method.rawValue), headers: HTTPHeaders(request.headers ?? [:]))
        .response { response in
            print("status: \(response.response?.statusCode)")
            if let error = response.error {
                completion(.failure(error))
            } else {
                do {
                    if let data = response.data {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        let apiResponse = APIResponse(data: decodedData, error: nil, statusCode: response.response?.statusCode)
                        completion(.success(apiResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    //MARK: - 
    public func uploadMultiMediaAttachment(url: String, file: MultiMediaAttachmentFile, headers: HTTPHeaders? = nil,completionHandler:@escaping (_ result:NSDictionary,_ statusCode:Int)->()) {
        guard reachabilityManager?.isReachable == true else {
            let json:[String: String] = [
                "status": "nointernet",
                "response": "503"
            ]
            debugPrint("No internet connection")
            completionHandler(json as NSDictionary, 503)
            return
        }
        
        AF.upload(file.data, to: url, method: HTTPMethod(rawValue: RTHTTPMethod.put.rawValue), headers: headers).responseJSON { response in
            
            if let statusCode = response.response?.statusCode, statusCode == 200{
                let json:[String: String] = [
                    "status": "Success",
                    "response": "200"
                ]
                completionHandler(json as NSDictionary, response.response?.statusCode ?? 200)
            } else {
                let json:[String: String] = [
                    "status": "failed",
                    "response": "\(response.response?.statusCode ?? .zero)"
                ]
                completionHandler(json as NSDictionary, response.response?.statusCode ?? .zero)
                return
            }
        }
    }
}
extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8) {
            append(data)
        }
    }
}

/*
 

 */
