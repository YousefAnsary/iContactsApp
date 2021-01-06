//
//  ContactTableCell.swift
//  iContacts
//
//  Created by Yousef on 1/3/21.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var phoneNumbersCountLbl: UILabel!
    @IBOutlet private weak var emailsCountLbl: UILabel!
    
    var contact: Contact? {
        didSet {
            nameLbl.text = contact?.name
            phoneNumbersCountLbl.text = "\(contact?.phoneNumbers?.count ?? 0) numbers"
            emailsCountLbl.text = "\(contact?.emails?.count ?? 0) emails"
        }
    }
    
}
