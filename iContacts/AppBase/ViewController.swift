//
//  ViewController.swift
//  iContacts
//
//  Created by Yousef on 5/3/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import UIKit
import JGProgressHUD
import RxSwift

class ViewController<T: ViewModel>: UIViewController {

    var viewModel: T?
    let hud = JGProgressHUD(style: .dark)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "Loading..."
        if viewModel != nil { configureViewModel(viewModel!) }
    }

    ///Subscribes view model to handle errors, messages, loading indicators
    func configureViewModel(_ vm: ViewModel) {
        vm.isLoadingSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] bool in
            if bool { self.showLoader() } else { self.hideLoader() }
        }).disposed(by: disposeBag)
        vm.messagesSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] msg in
            self.displayAlert(message: msg)
        }).disposed(by: disposeBag)
        vm.errorSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] err in
            self.handleError(err)
        }).disposed(by: disposeBag)
    }
    
    func showLoader() {
        self.hud.show(in: self.view)
    }
    
    func hideLoader() {
        self.hud.dismiss()
    }
    
    func restartApp() {
        guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else {return}
        sceneDelegate.coordinator?.start()
    }
    
    func displayAlert(withTitle title: String? = nil, message: String, btnHandler: ((UIAlertAction)-> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: btnHandler)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    func displaySuccessHUD(dismissingIn time: Double = 0.6, completion: (()-> Void)? = nil) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Success"
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.show(in: self.view, animated: true)
            hud.dismiss(afterDelay: time, animated: true)
            guard completion != nil else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: completion!)
        }
    }
    
    func displayErrorHUD(dismissingIn time: Double = 0.6, completion: (()-> Void)? = nil) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Error!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view, animated: true)
            hud.dismiss(afterDelay: time, animated: true)
            guard completion != nil else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: completion!)
        }
    }
    
    func handleError(_ error: Error) {
        self.hideLoader()
        guard let apiError = error as? APIError else {
            print("API Request Error: \((error as NSError))")
            displayAlert(withTitle: "Unexpected Error", message: "code: \((error as NSError).code)", btnHandler: nil)
            return
        }
        switch apiError {
        case .unauthenticated:
            displayAlert(withTitle: "Error", message: error.localizedDescription, btnHandler: { _ in
                UserSession.endCurrent()
                self.restartApp()
            })
        default:
            displayAlert(withTitle: "Error", message: error.localizedDescription, btnHandler: nil)
        }
    }
}

