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
    }
    
    //MARK: - Private Functions
    private func bindViewModel() {
        guard viewModel != nil else {fatalError("ViewModel is nil")}
        emailTF.rx.text.orEmpty.bind(to: viewModel!.emailRelay).disposed(by: disposeBag)
        passwordTF.rx.text.orEmpty.bind(to: viewModel!.passwordRelay).disposed(by: disposeBag)
        viewModel!.loginBtnEnableDriver.drive(loginBtn.rx.isEnabled).disposed(by: disposeBag)
        viewModel!.loginBtnColorDriver.drive(loginBtn.rx.backgroundColor).disposed(by: disposeBag)
        loginBtn.rx.tap.flatMap { [unowned self] in
            self.viewModel!.login()
        }.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] value in
            self.navigateToHome?()
        }).disposed(by: disposeBag)
    }
    
}
