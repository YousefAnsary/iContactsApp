//
//  UserSession.swift
//  iContacts
//
//  Created by Yousef on 1/2/21.
//

import Foundation

class UserSession {
    
    private static let userDataKey = "UserData"
    var email: String
    var name: String
    var token: String
    var tokenExpireDate: Date
    var isTokenExpired: Bool
    
    private init(userData: UserData) {
        self.email = userData.email
        self.name = userData.name
        self.token = "Bearer \(userData.token)"
        self.tokenExpireDate = userData.tokenExpireDate
        self.isTokenExpired = self.tokenExpireDate >= Date()
    }
    
    private static var session: UserSession?
    
    static var current: UserSession? {
        get {
            if session != nil { return session }
            guard let data = UserDefaults.standard.data(forKey: userDataKey),
                  let decodedData = try? JSONDecoder().decode(UserData.self, from: data) else {
                    return nil
            }
            session = UserSession(userData: decodedData)
            return session
        }
    }
    
    class func endCurrent() {
        UserDefaults.standard.setValue(nil, forKey: userDataKey)
        session = nil
    }
    
    class func startSession(withData data: UserData) {
        session = UserSession(userData: data)
        let encodedData = try? JSONEncoder().encode(data)
        UserDefaults.standard.setValue(encodedData, forKey: userDataKey)
    }
    
}
