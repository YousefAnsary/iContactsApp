//
//  APIError.swift
//  iContacts
//
//  Created by Yousef on 12/31/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import Foundation

enum APIError: LocalizedError {
    
    case badRequest(data: Data?)
    case unauthenticated
    case unauthorized
    case notFound
    case methodNotAllowed
    case internalServerError
    case decodingFailed
    case unknownError(Int)
    
    init(statusCode: Int, data: Data? = nil) {
        switch statusCode {
        case 400:
            self = .badRequest(data: data)
        case 401:
            self = .unauthenticated
        case 403:
            self = .unauthorized
        case 404:
            self = .notFound
        case 405:
            self = .methodNotAllowed
        case 500:
            self = .internalServerError
        default:
            self = .unknownError(statusCode)
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .badRequest(_):
            return false
        case .unauthenticated:
            return false
        case .unauthorized:
            return false
        case .methodNotAllowed:
            return false
        case .internalServerError:
            return true
        case .decodingFailed:
            return true
        case .notFound:
            return true
        case .unknownError:
            return true
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .badRequest(let data):
            return "\((try? data?.toDictionsay()?["error"] as? String) ??  "unexpected error with code: 400")"
        case .unauthenticated:
            return "Session Problem, You need to Re-Login"
        case .unauthorized:
            return "You don't have permessions to do this operation"
        case .methodNotAllowed:
            return "unexpected error with code: (405)"
        case .internalServerError:
            return "unexpected error with code: (500)"
        case .decodingFailed:
            return "unexpected error with code: (200)"
        case .notFound:
            return "404 Not Found"
        case .unknownError(let code):
            return "unexpected error with code: \(code)"
        }
    }
    
    var errorDescription: String? {
        self.localizedDescription
    }
}
