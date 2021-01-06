//
//  Request+RxSwift.swift
//  iContacts
//
//  Created by Yousef on 12/31/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import JetRequest
import RxSwift

extension Request {
    
    var observable: Observable<(response: HTTPURLResponse, data: Data)> {
        get {
            return URLSession.shared.rx.response(request: self.urlRequest)
        }
    }
    
    func decodedObservable<T: Codable>()-> Observable<T> {
        self.observable.map { (res, data) -> T in
            guard 200...299 ~= res.statusCode else {throw APIError(statusCode: res.statusCode)}
            do {
                return try JSONHelper.decode(data)//data.decode(to: T.self)
            } catch {
                print("Error Decoding: \(error)")
                throw APIError.decodingFailed
            }
        }
    }
    
}
