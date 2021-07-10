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
    
    var completable: Completable {
        Completable.create { completable -> Disposable in
            return self.singleObservable.subscribe { _ in
                completable(.completed)
            } onError: { err in
                completable(.error(err))
            }
        }
    }
    
    var singleObservable: Single<Data> {
        get {
            return URLSession.shared.rx.response(request: self.urlRequest).asSingle().map { (res, data) in
                guard 200 ... 299 ~= res.statusCode else { throw APIError(statusCode: res.statusCode) }
                return data
            }
        }
    }
    
//    func decodedSingleObservable<T: Codable>()-> Single<T> {
//        self.singleObservable.map { (res, data) -> T in
//            guard 200...299 ~= res.statusCode else {throw APIError(statusCode: res.statusCode)}
//            do {
//                return try JSONHelper.decode(data)//data.decode(to: T.self)
//            } catch {
//                print("Error Decoding: \(error)")
//                throw APIError.decodingFailed
//            }
//        }
//    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Data {
    
    func decode<T: Decodable>(toType type: T.Type, using decoder: JSONDecoder = JSONHelper.decoder) -> Single<T> {
        self.map { (data: Data) -> T in
            do {
                return try decoder.decode(type.self, from: data)
            } catch {
                print("Error Decoding: \(error)")
                throw APIError.decodingFailed
            }
        }
    }
}
