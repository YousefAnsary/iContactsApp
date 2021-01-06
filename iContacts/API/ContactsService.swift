//
//  ContactsService.swift
//  iContacts
//
//  Created by Yousef on 1/3/21.
//

import JetRequest
import RxSwift

class ContactsService {
    
    class func getContacts()-> Observable<[Contact]> {
        let ep = Endpoint.getContacts
        let headers = ["Authorization": UserSession.current?.token ?? ""]
        return JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod)
                         .set(headers: headers).decodedObservable()
    }
    
    class func create(contact: Contact)-> Observable<()> {
        let ep = Endpoint.addContact
        let headers = ["Authorization": UserSession.current?.token ?? "", "Content-Type": "application/json"]
        let req = JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod).set(headers: headers)
        req.urlRequest.httpBody = try! JSONHelper.encode([contact])
        return req.observable.map { res, data in
            if !(200...299 ~= res.statusCode) { throw APIError(statusCode: res.statusCode) }
        }
    }
    
    class func update(contact: Contact)-> Observable<()> {
        let ep = Endpoint.updateContact
        let headers = ["Authorization": UserSession.current?.token ?? "", "Content-Type": "application/json"]
        let req = JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod).set(headers: headers)
        req.urlRequest.httpBody = try! JSONHelper.encode(contact)
        return req.observable.map { res, data in
            if !(200...299 ~= res.statusCode) { throw APIError(statusCode: res.statusCode) }
        }
    }
    
    class func deleteContact(withId id: Int)-> Observable<()> {
        let ep = Endpoint.deleteContact
        let headers = ["Authorization": UserSession.current?.token ?? ""]
        let params = ["contactId": id]
        return JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod).set(urlParams: params).set(headers: headers)
               .observable.map { res, data in
                    if !(200...299 ~= res.statusCode) { throw APIError(statusCode: res.statusCode) }
               }
    }
    
}
