//
//  Endpoints.swift
//  iContacts
//
//  Created by Yousef on 12/31/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import JetRequest

enum Endpoint: String {
    
    case login = "login"
    case register = "register"
    case getContacts = "contacts/get"
    case addContact = "contacts/create"
    case deleteContact = "contacts/delete"
    case updateContact = "contacts/update"
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login:
            return HTTPMethod.post
        case .register:
            return HTTPMethod.post
        case .getContacts:
            return HTTPMethod.get
        case .addContact:
            return HTTPMethod.post
        case .deleteContact:
            return HTTPMethod.delete
        case .updateContact:
            return HTTPMethod.patch
        }
    }
    
    var requiresAuthorization: Bool {
        switch self {
        case .login:
            return false
        case .register:
            return false
        case .getContacts:
            return true
        case .addContact:
            return true
        case .deleteContact:
            return true
        case .updateContact:
            return true
        }
    }
    
    var headers: [String: String] {
        let bundleIdentifier =  Bundle.main.bundleIdentifier ?? ""
        var headers = ["User-Agent": "\(bundleIdentifier)/JetRequest", "Accept": "*/*"]
        if self.requiresAuthorization {
            headers["Authorization"] = UserSession.current?.token ?? ""
        }
        return headers
    }
    
}
