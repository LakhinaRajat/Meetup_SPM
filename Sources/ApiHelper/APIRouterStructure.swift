//
//  APIRouterStructure.swift
//

import Foundation
import Alamofire

struct APIRouterStructure:URLRequestConvertible {
    
    let apiRouter:APIRouter
    
    var token:String = ""
    
    var header:HTTPHeaders{
        
        var header:[String:String] = [:]
        if !GlobalConfig.sessionToken.isEmpty {
            header["Authorization"] = "Bearer \(GlobalConfig.sessionToken)"
        }
        
        if let additionalHeaders = apiRouter.additionalHeaders {
            let additionalHeadersDictionary = additionalHeaders
            var addHeader:[String:String] = [:]
            additionalHeadersDictionary.forEach { (key, value) in
                addHeader[key] = value
            }
            header["user-agent"] = Utility.jsonSting(from: addHeader)
        }
        return HTTPHeaders(header)
    }
    
    var encryptedHeader:HTTPHeaders {
        
        var header:[String:String] = [:]
        if !GlobalConfig.encryptAccessToken.isEmpty {
            header["Authorization"] = "Bearer \(GlobalConfig.encryptAccessToken)"
        }
        
        if let additionalHeaders = apiRouter.additionalHeaders {
            let additionalHeadersDictionary = additionalHeaders
            var addHeader:[String:String] = [:]
            additionalHeadersDictionary.forEach { (key, value) in
                addHeader[key] = value
            }
            header["user-agent"] = Utility.jsonSting(from: addHeader)
        }
        return HTTPHeaders(header)
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try apiRouter.baseURL.asURL()
        url.appendPathComponent(apiRouter.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRouter.method.rawValue
        urlRequest.timeoutInterval = apiRouter.timeout
        
        if apiRouter.path == "public-resource/login" {
            urlRequest.headers = self.encryptedHeader
        } else {
            urlRequest.headers = self.header
        }
        
        if apiRouter.isURLEncoded {
            if let encoding = apiRouter.encoding {
                urlRequest = try encoding.encode(urlRequest, with: apiRouter.parameters)
            }
        } else {
            if let parameters = apiRouter.parameters {
                
                print("---------------------------------------------------------------")
                print("Payload json -> \(parameters.stringifyDictionary())")
                print("---------------------------------------------------------------")
                
                // Safely unwrap and construct the query string
                var queryString = ""
                for (key, value) in parameters {
                    if !queryString.isEmpty {
                        queryString += "&"
                    }
                    queryString += "\(key)=\(value)"
                }
                // Append the query string to the URL
                if let originalURL = urlRequest.url {
                    let urlString = originalURL.absoluteString + "?" + queryString
                    urlRequest.url = URL(string: urlString)
                }
            }
        }
        return urlRequest
    }
}
