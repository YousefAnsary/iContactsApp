//
//  JSONHelper.swift
//  iContacts
//
//  Created by Yousef on 1/3/21.
//

import Foundation

class JSONHelper {
    
    static var decoder = JSONDecoder()
    static var encoder = JSONEncoder()
    static var dateDecodingFormat: String? = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    class func decode<T: Codable>(_ data: Data) throws -> T {
        if let dateDecodingFormat = dateDecodingFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateDecodingFormat
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        }
        return try decoder.decode(T.self, from: data)
    }
    
    class func encode<T: Codable>(_ object: T) throws -> Data {
        return try encoder.encode(object)
    }
    
}
