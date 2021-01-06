//
//  HomeViewModel.swift
//  iContacts
//
//  Created by Yousef on 1/3/21.
//

import RxSwift
import RxCocoa

class HomeViewModel: ViewModel {
    
    deinit {
        print("\(self) deinit")
    }
    
    let contactsRelay: BehaviorRelay<[Contact]>
    
    override init() {
        contactsRelay = .init(value: [])
    }
    
    func getContacts() {
        self.isLoadingSubject.onNext(true)
        return ContactsService.getContacts().catchError { err in
            self.isLoadingSubject.onNext(false)
            self.errorSubject.onNext(err)
            return .empty()
        }.do(onNext: { value in
            self.isLoadingSubject.onNext(false)
        }).bind(to: contactsRelay).disposed(by: disposeBag)
    }
    
    func deleteContact(atIndex index: Int) {
        isLoadingSubject.onNext(true)
        ContactsService.deleteContact(withId: contactsRelay.value[index].id ?? -1).catchError { [weak self] err in
            self?.isLoadingSubject.onNext(false)
            self?.errorSubject.onNext(err)
            return .empty()
        }.subscribe(weak: self, onNext: { owner, _ in
            owner.isLoadingSubject.onNext(false)
            var contacts = owner.contactsRelay.value
            contacts.remove(at: index)
            owner.contactsRelay.accept(contacts)
        }).disposed(by: disposeBag)
    }
    
    func contactDidAdd(_ contact: Contact) {
        var contacts = contactsRelay.value
        contacts.append(contact)
        contactsRelay.accept(contacts)
    }
    
    func contactDidUpdated(atIndex index: Int, _ contact: Contact) {
        var contacts = contactsRelay.value
        contacts[index] = contact
        contactsRelay.accept(contacts)
    }
    
}
