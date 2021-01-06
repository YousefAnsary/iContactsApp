//
//  UITableView+.swift
//  iContacts
//
//  Created by Yousef on 1/5/21.
//

import UIKit

extension UITableView {
    
    func register(cellClass: UITableViewCell.Type) {
        let name = String(describing: cellClass)
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func dequeue<T: UITableViewCell>()-> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
    
}
