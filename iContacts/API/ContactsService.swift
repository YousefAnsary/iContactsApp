//
//  ContactsService.swift
//  iContacts
//
//  Created by Yousef on 1/3/21.
//

import JetRequest
import RxSwift

class ContactsService {
    
    class func getContacts()-> Single<[Contact]> {
        let ep = Endpoint.getContacts
        let headers = ["Authorization": UserSession.current?.token ?? ""]
        return JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod)
            .set(headers: headers).singleObservable.decode(toType: [Contact].self)
    }
    
    class func create(contact: Contact)-> Completable {
        let ep = Endpoint.addContact
        let headers = ["Authorization": UserSession.current?.token ?? "", "Content-Type": "application/json"]
        let req = JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod).set(headers: headers)
        req.urlRequest.httpBody = try! JSONHelper.encode([contact])
        return req.completable
    }
    
    class func update(contact: Contact)-> Completable {
        let ep = Endpoint.updateContact
        let headers = ["Authorization": UserSession.current?.token ?? "", "Content-Type": "application/json"]
        let req = JetRequest.request(path: ep.rawValue, httpMethod: ep.httpMethod).set(headers: headers)
        req.urlRequest.httpBody = try! JSONHelper.encode(contact)
        return req.completable
    }
    
    class func deleteContact(withId id: Int)-> Completable {
        let ep = Endpoint.deleteContact
        let headers = ["Authorization": UserSession.current?.token ?? ""]
        let params = ["contactId": id]
        return JetRequest.request(
            path: ep.rawValue,
            httpMethod: ep.httpMethod
        ).set(urlParams: params)
         .set(headers: headers)
         .completable
    }
    
}
