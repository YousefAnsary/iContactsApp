//
//  InputTableViewCell.swift
//  iContacts
//
//  Created by Yousef on 1/4/21.
//

import UIKit
import RxSwift

class InputCell: UITableViewCell {

    @IBOutlet weak var inputTF: TextField!
    @IBOutlet weak var deleteBtn: UIButton!
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    

}
