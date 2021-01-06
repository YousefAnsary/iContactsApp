//
//  UIVIewController+.swift
//  iContacts
//
//  Created by Yousef on 1/2/21.
//

import UIKit

typealias ParameterlessCompletion = ()-> ()

extension UIViewController {
    
    static func initialize(fromStoryBoardNamed storyboardName: String)-> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
    
    func displayAlert(withMsg msg: String, title: String? = nil, btnHandler: ParameterlessCompletion? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { ـ in
            btnHandler?()
        }))
        present(alert, animated: true)
    }
    
}
