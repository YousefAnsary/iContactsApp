//
//  RegisterViewController.swift
//  iContacts
//
//  Created by Yousef on 1/3/21.
//

import UIKit
import RxSwift

class RegisterViewController: ViewController<RegisterViewModel> {

    //MARK: - Variables
    @IBOutlet private weak var nameTF: UITextField!
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var confirmPasswordTF: UITextField!
    @IBOutlet private weak var registerBtn: UIButton!
    var navigateToHome: (()-> Void)?
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    //MARK: - Private Methods
    private func bindViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel is nil") }
        nameTF.rx.text.orEmpty.bind(to: viewModel.nameRelay).disposed(by: disposeBag)
        emailTF.rx.text.orEmpty.bind(to: viewModel.emailRelay).disposed(by: disposeBag)
        passwordTF.rx.text.orEmpty.bind(to: viewModel.passwordRelay).disposed(by: disposeBag)
        confirmPasswordTF.rx.text.orEmpty.bind(to: viewModel.confirmPasswordRelay).disposed(by: disposeBag)
        viewModel.registerBtnEnableDriver.drive(registerBtn.rx.isEnabled).disposed(by: disposeBag)
        viewModel.registerBtnColorDriver.drive(registerBtn.rx.backgroundColor).disposed(by: disposeBag)
        registerBtn.rx.tap.flatMap{
            viewModel.register()
        }.observeOn(MainScheduler.instance).asCompletable().subscribe(onCompleted: { [unowned self] in
            self.navigateToHome?()
        }).disposed(by: disposeBag)
    }
}
