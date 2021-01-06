//
//  UserData.swift
//  iContacts
//
//  Created by Yousef on 12/31/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import Foundation

struct UserData: Codable {
    
    var name: String
    var email: String
    var token: String
    var tokenCreationDate: Date
    var tokenExpireDate: Date
    
}
