//
//  AddContactViewModel.swift
//  iContacts
//
//  Created by Yousef on 1/4/21.
//

import RxSwift
import RxCocoa

class AddContactViewModel: ViewModel {
    
    deinit {
        print("\(self) deinit")
    }
    
    private var numbers: [String]
    private var emails: [String]
    private let isEditing: Bool
    let nameRelay: BehaviorRelay<String>
    let numbersRelay: BehaviorRelay<[String]>
    let emailsRelay: BehaviorRelay<[String]>
    let numbersTableHeightDriver: Driver<CGFloat>
    let emailsTableHeightDriver: Driver<CGFloat>
    private let contactDidAdd: ((Contact)-> Void)?
    private let contactDidEdit: ((Int, Contact)-> Void)?
    private let index: Int?
    private let id: Int?
    
    init(addSuccessCompletion: @escaping (Contact)-> Void) {
        isEditing = false
        numbers = [""]
        emails = [""]
        nameRelay = .init(value: "")
        numbersRelay = .init(value: [""])
        emailsRelay = .init(value: [""])
        numbersTableHeightDriver = numbersRelay.map { CGFloat($0.count * 60) }.asDriver(onErrorJustReturn: 0)
        emailsTableHeightDriver = emailsRelay.map{CGFloat($0.count * 60)}.asDriver(onErrorJustReturn: 0)
        contactDidAdd = addSuccessCompletion
        contactDidEdit = nil
        index = nil
        id = nil
    }
    
    init(contact: Contact, index: Int, editSuccessCompletion: @escaping(Int, Contact)-> Void) {
        isEditing = true
        numbers = contact.phoneNumbers ?? [""]
        emails = contact.emails ?? [""]
        nameRelay = .init(value: contact.name ?? "")
        numbersRelay = .init(value: numbers)
        emailsRelay = .init(value: emails)
        numbersTableHeightDriver = numbersRelay.map { CGFloat($0.count * 60) }.asDriver(onErrorJustReturn: 0)
        emailsTableHeightDriver = emailsRelay.map { CGFloat($0.count * 60) }.asDriver(onErrorJustReturn: 0)
        contactDidEdit = editSuccessCompletion
        contactDidAdd = nil
        self.index = index
        id = contact.id
    }
    
    func doneBtnTapped()-> Completable {
        self.isLoadingSubject.onNext(true)
        let sendNumbers = numbers.filter{ !$0.isEmpty }
        let sendEmails = emails.filter{ !$0.isEmpty }
        let contact = Contact(id: id, name: nameRelay.value, phoneNumbers: sendNumbers, emails: sendEmails)
        let requestObservable = isEditing ? ContactsService.update(contact: contact) : ContactsService.create(contact: contact)
        return requestObservable.do(onError: { [weak self] err in
            self?.errorSubject.onNext(err)
        }, onCompleted: { [weak self] in
            guard let self = self else {return}
            self.isLoadingSubject.onNext(false)
            if self.isEditing {
                self.contactDidEdit?(self.index!, contact)
            } else {
                self.contactDidAdd?(contact)
            }
        })
    }
    
    func addNumberBtnTapped() {
        numbers.append("")
        numbersRelay.accept(numbers)
    }
    
    func addEmailBtnTapped() {
        emails.append("")
        emailsRelay.accept(emails)
    }
    
    func setupNumberTableCell(_ cell: InputCell, index: Int) {
        cell.deleteBtn.isHidden = (index == 0 && numbers.count < 2) || index == numbers.count - 1
        cell.inputTF.text = numbers[index]
        cell.inputTF.placeholder = "Number"
        cell.inputTF.rx.value.orEmpty.skip(1).subscribe(weak: self, onNext: { owner, string in
            if index < owner.numbers.count {
                owner.numbers[index] = string
            } else {
                owner.numbers.append(string)
            }
        }).disposed(by: cell.disposeBag)
        cell.inputTF.rx.controlEvent(.editingDidEnd).subscribe(weak: self, onNext: { owner, _ in
//            if index == owner.numbers.count - 1 && !owner.numbers[index].isEmpty {
//                owner.numbers.append("")
//            }
            owner.numbersRelay.accept(owner.numbers)
        }).disposed(by: cell.disposeBag)
        
        cell.deleteBtn.rx.tap.subscribe(weak: self, onNext: { owner, _ in
            owner.numbers.remove(at: index)
            owner.numbersRelay.accept(owner.numbers)
        }).disposed(by: cell.disposeBag)
    }
    
    func setupEmailTableCell(_ cell: InputCell, index: Int) {
        cell.deleteBtn.isHidden = (index == 0 && emails.count < 2) || index == emails.count - 1
        cell.inputTF.placeholder = "E-Mail"
        cell.inputTF.text = emails[index]
        cell.inputTF.rx.value.orEmpty.skip(1).subscribe(weak: self, onNext: { owner, string in
            if index < owner.emails.count {
                owner.emails[index] = string
            } else {
                owner.emails.append(string)
            }
        }).disposed(by: cell.disposeBag)
        
        cell.inputTF.rx.controlEvent(.editingDidEnd).subscribe(weak: self, onNext: { owner, _ in
//            if index == owner.emails.count - 1 && !owner.emails[index].isEmpty {
//                owner.emails.append("")
//            }
            owner.emailsRelay.accept(owner.emails)
        }).disposed(by: cell.disposeBag)
        
        cell.deleteBtn.rx.tap.subscribe(weak: self, onNext: { owner, _ in
            owner.emails.remove(at: index)
            owner.emailsRelay.accept(owner.emails)
        }).disposed(by: cell.disposeBag)
    }
}
