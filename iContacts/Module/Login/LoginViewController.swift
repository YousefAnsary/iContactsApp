//
//  LoginViewController.swift
//  iContacts
//
//  Created by Yousef on 12/31/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: ViewController<LoginViewModel> {

    //MARK: - Variables
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var loginBtn: UIButton!
    @IBOutlet private weak var registerBtn: UIButton!
    
    var navigateToRegister: (()-> Void)?
    var navigateToHome: (()-> Void)?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindBtnsActions()
    }
    
    //MARK: - Private Functions
    private func bindViewModel() {
        guard viewModel != nil else { fatalError("ViewModel is nil") }
        emailTF.rx.text.orEmpty.bind(to: viewModel!.emailRelay).disposed(by: disposeBag)
        passwordTF.rx.text.orEmpty.bind(to: viewModel!.passwordRelay).disposed(by: disposeBag)
        viewModel!.loginBtnEnableDriver.drive(loginBtn.rx.isEnabled).disposed(by: disposeBag)
        viewModel!.loginBtnColorDriver.drive(loginBtn.rx.backgroundColor).disposed(by: disposeBag)
    }
    
    private func bindBtnsActions() {
        loginBtn.rx.tap.flatMap { [unowned self] in
            self.viewModel!.login()
        }.observeOn(MainScheduler.instance).asCompletable()
        .subscribe(onCompleted: { [weak self] in
            self?.navigateToHome?()
        }).disposed(by: disposeBag)
        registerBtn.rx.tap.subscribe(weak: self, onNext: { owner, _ in
            owner.navigateToRegister?()
        }).disposed(by: disposeBag)
    }
}
