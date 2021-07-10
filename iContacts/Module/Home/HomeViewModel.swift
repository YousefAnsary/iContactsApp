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
        ContactsService.getContacts().subscribe { [weak self] contacts in
            self?.isLoadingSubject.onNext(false)
            self?.contactsRelay.accept(contacts)
        } onError: { [weak self] err in
            self?.errorSubject.onNext(err)
        }.disposed(by: self.disposeBag)
    }
    
    func deleteContact(atIndex index: Int) {
        isLoadingSubject.onNext(true)
        ContactsService.deleteContact(withId: contactsRelay.value[index].id ?? -1).subscribe { [weak self] in
            guard let self = self else { return }
            self.isLoadingSubject.onNext(false)
            var contacts = self.contactsRelay.value
            contacts.remove(at: index)
            self.contactsRelay.accept(contacts)
        } onError: { [weak self] err in
            self?.errorSubject.onNext(err)
        }.disposed(by: disposeBag)
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
