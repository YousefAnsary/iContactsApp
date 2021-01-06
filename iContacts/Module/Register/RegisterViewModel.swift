//
//  RegisterViewModel.swift
//  iContacts
//
//  Created by Yousef on 1/3/21.
//

import RxSwift
import RxCocoa

class RegisterViewModel: ViewModel {
    
    let nameRelay: BehaviorRelay<String>
    let emailRelay: BehaviorRelay<String>
    let passwordRelay: BehaviorRelay<String>
    let confirmPasswordRelay: BehaviorRelay<String>
    let registerBtnEnableDriver: Driver<Bool>
    let registerBtnColorDriver: Driver<UIColor>
    
    override init() {
        nameRelay = .init(value: "")
        emailRelay = .init(value: "")
        passwordRelay = .init(value: "")
        confirmPasswordRelay = .init(value: "")
        registerBtnEnableDriver = Observable.combineLatest(nameRelay, emailRelay, passwordRelay, confirmPasswordRelay).map{
            return !$0.isEmpty && $1.isValidEmail && $2.count > 5 && $2 == $3
        }.asDriver(onErrorJustReturn: false)
        registerBtnColorDriver = registerBtnEnableDriver.map{ return $0 ? #colorLiteral(red: 0.1304919422, green: 0.1321794689, blue: 0.6463773545, alpha: 0.6461365582) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6382973031) }
    }
    
    func register()-> Observable<UserData> {
        self.isLoadingSubject.onNext(true)
        let name = nameRelay.value, email = emailRelay.value, password = passwordRelay.value
        return AuthenticationService.register(email: email, userName: name, password: password).catchError { err in
            self.isLoadingSubject.onNext(false)
            self.errorSubject.onNext(err)
            return .empty()
        }.do(onNext: { value in
            UserSession.startSession(withData: value)
            self.isLoadingSubject.onNext(false)
        })
    }
    
}
