//
//  APIManager.swift
//  iContacts
//
//  Created by Yousef on 12/31/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import JetRequest
import RxSwift

class AuthenticationService {
    
    class func login(email: String, password: String)-> Observable<UserData> {
        let ep = Endpoint.login
        let params = ["email": email, "password": password]
        var headers = ep.headers
        let boundary = "\(Bundle.main.bundleIdentifier ?? "iOSApp")/JetRequest"
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        return JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod)
               .set(bodyParams: params, encoding: .formData).decodedObservable()
    }
    
    class func register(email: String, userName: String, password: String)-> Observable<UserData> {
        let ep = Endpoint.register
        let params = ["email": email, "name": userName, "password": password, "confirmPassword": password]
        return JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod)
               .set(bodyParams: params, encoding: .formData).decodedObservable() 
    }
    
}
