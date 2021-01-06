//
//  AppCoordinator.swift
//  iContacts
//
//  Created by Yousef on 12/4/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    private var navigationController: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
        
    }
    
    func start() {
//        UserSession.endCurrent()
        if UserSession.current == nil {
            startAsUnAuthenticated()
        } else {
            startAsAuthenticated()
        }
    }
    
    private func startAsAuthenticated() {
        let vc = HomeViewController.initialize(fromStoryBoardNamed: "Main")
        let vm = HomeViewModel()
        vc.viewModel = vm
        vc.navigateToAddContact = {
            let addVC = AddContactViewController.initialize(fromStoryBoardNamed: "Main")
            let addVM = AddContactViewModel(addSuccessCompletion: vm.contactDidAdd(_:))
//            addVM.contactDidAdd = { contact in
//                vm.contactDidAdd(contact)
//            }
            addVC.viewModel = addVM
            vc.present(addVC, animated: true)
        }
        vc.navigateToEditContact = { index in
            let addVC = AddContactViewController.initialize(fromStoryBoardNamed: "Main")
            let contact = vm.contactsRelay.value[index]
            let addVM = AddContactViewModel(contact: contact, index: index, editSuccessCompletion: vm.contactDidUpdated(atIndex:_:))
//            addVM.contactDidAdd = { contact in
//                vm.contactDidAdd(contact)
//            }
            addVC.viewModel = addVM
            vc.present(addVC, animated: true)
        }
        setupNavigationController()
        navigationController.pushViewController(vc, animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func startAsUnAuthenticated() {
        let vc = LoginViewController.initialize(fromStoryBoardNamed: "Main")
        vc.viewModel = LoginViewModel()
        vc.navigateToHome = startAsAuthenticated
        vc.navigateToRegister = {
            let vc = RegisterViewController.initialize(fromStoryBoardNamed: "Main")
            let vm = RegisterViewModel()
            vc.viewModel = vm
            vc.navigateToHome = self.startAsAuthenticated
        }
        setupNavigationController()
        navigationController.pushViewController(vc, animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func setupNavigationController() {
        navigationController = UINavigationController()
//        navigationController.navigationBar.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.1960784314, alpha: 0.9478007277)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = .clear
    }
    
}
