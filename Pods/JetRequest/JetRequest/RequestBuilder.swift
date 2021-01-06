//
//  RequestBuilder.swift
//  JetRequest
//
//  Created by Yousef on 9/25/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import Foundation

internal class RequestBuilder {
    
    internal static func url(fromString string: String)-> URL {
        guard let url = URL(string: string) else { fatalError("JetRequest.Error: Invalid URL: \(string)") }
        return url
    }
    
    internal static func urlRequest(fromURL url: URL)-> URLRequest {
        return URLRequest(url: url)
    }
    
    internal static func setupQuery(forUrl url: String, params: [String: Any]?)-> URL {
        var urlComponents = URLComponents(string: url)
        urlComponents?.query = queryString(fromDict: params)
        precondition(urlComponents?.url != nil, "Invalid URL: \(url)")
        return urlComponents!.url!
    }
    
    internal static func queryString(fromDict dict: [String: Any]?)-> String? {
        return dict?.map { key, val in "\(key)=\(val)" }.joined(separator: "&")
    }
    
    internal static func setupURLRequest(url: URL, httpMethod: HTTPMethod, headers: [String: String]?)-> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        return urlRequest
    }
    
    internal static func setupBodyParams(forUrlRequest request: inout URLRequest, bodyParams: [String: Any?]?) {
        guard let bodyParams = bodyParams else { return }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
        } catch {
            print("invalid body params with err: \(error.localizedDescription)")
        }
        
    }
    
    internal static func setupFormDataParams(forUrlRequest request: inout URLRequest, params: [String: Any?]?) {
        guard let params = params else {return}
//        let boundary = "\(Bundle.main.bundleIdentifier ?? "iOSApp")/JetRequest"
//        let string = "--\(boundary)\r\n"
//        let body = NSMutableData()
//        // add params (all params are strings)
//        for (key, value) in params {
//            body.append("--\(boundary)\r\n".data(using: .utf8)!);
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!);
//            body.append("\(value ?? "nil")\r\n".data(using: .utf8)!);
//        }
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!);
        let data = params.map{"\($0.key)=\($0.value ?? "null")"}.joined(separator: "&")
        request.httpBody = data.data(using: .utf8)
    }
    
}
