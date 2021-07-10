//
//  ViewModel.swift
//  iContacts
//
//  Created by Yousef on 12/31/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import RxSwift

class ViewModel {
    
    let isLoadingSubject = PublishSubject<Bool>()
    let messagesSubject = PublishSubject<String>()
    let errorSubject = PublishSubject<Error>()
    let disposeBag = DisposeBag()
}
