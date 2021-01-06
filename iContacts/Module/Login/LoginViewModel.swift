//
//  LoginViewModel.swift
//  iContacts
//
//  Created by Yousef on 12/31/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel: ViewModel {
    
    let emailRelay: BehaviorRelay<String>
    let passwordRelay: BehaviorRelay<String>
    let loginBtnEnableDriver: Driver<Bool>
    let loginBtnColorDriver: Driver<UIColor>
    
    override init() {
        emailRelay = .init(value: "")
        passwordRelay = .init(value: "")
        loginBtnEnableDriver = Observable.combineLatest(emailRelay, passwordRelay)
                                         .map{$0.isValidEmail && $1.count > 5}
                                         .asDriver(onErrorJustReturn: false)
        loginBtnColorDriver = loginBtnEnableDriver.map{ return $0 ? #colorLiteral(red: 0.1304919422, green: 0.1321794689, blue: 0.6463773545, alpha: 0.6461365582) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6382973031) }
    }
    
    func login()-> Observable<UserData> {
        self.isLoadingSubject.onNext(true)
        return AuthenticationService.login(email: emailRelay.value, password: passwordRelay.value).catchError { err in
            self.isLoadingSubject.onNext(false)
            if case APIError.unauthenticated = err {
                self.messagesSubject.onNext("Wrong Credentials")
            } else {
                self.errorSubject.onNext(err)
            }
            return .empty()
        }.do(onNext: { value in
            UserSession.startSession(withData: value)
            self.isLoadingSubject.onNext(false)
        })
    }
    
}
