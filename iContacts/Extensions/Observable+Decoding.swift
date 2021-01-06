//
//  Observable+Decoding.swift
//  iContacts
//
//  Created by Yousef on 1/5/21.
//

import RxSwift

extension Observable where Element == Data {
    
    func decode<T: Codable>()-> Observable<T> {
        return map { data -> T in
            return try data.decode(to: T.self)
        }
    }
    
}
