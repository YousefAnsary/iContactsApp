//
//  HomeViewController.swift
//  iContacts
//
//  Created by Yousef on 1/3/21.
//

import UIKit
import RxSwift

class HomeViewController: ViewController<HomeViewModel>, UITableViewDelegate {

    deinit {
        print("\(self) deinit")
    }
    
    //MARK: - Variables
    @IBOutlet private weak var contactsTableView: UITableView!
    @IBOutlet private weak var addContactBtn: UIButton!
    var navigateToAddContact: (()-> Void)?
    var navigateToEditContact: ((Int)-> Void)?
    var logutDidTapped: (()-> Void)?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarBtns()
        setupTableView()
        setupButtonsBinding()
        bindViewModel()
        viewModel?.getContacts()
        
    }
    
    //MARK: - Private Functions
    private func setupNavigationBarBtns() {
        let logoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutDidTapped))
        navigationItem.leftBarButtonItem = logoutBtn
    }
    
    @objc private func logoutDidTapped() {
        logutDidTapped?()
    }
    
    private func setupTableView() {
        contactsTableView.register(cellClass: ContactCell.self)
        contactsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        contactsTableView.rx.itemDeleted.subscribe(weak: self, onNext: { owner, index in
            owner.viewModel!.deleteContact(atIndex: index.row)
        }).disposed(by: disposeBag)
        
        contactsTableView.rx.itemInserted.subscribe(weak: self, onNext: { owner, index in
            owner.navigateToEditContact?(index.row)
        }).disposed(by: disposeBag)
        
        contactsTableView.rx.itemSelected.subscribe(weak: self, onNext: { owner, indx in
            owner.tableCellDidSelected(at: indx.row)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupButtonsBinding() {
        addContactBtn.rx.tap.subscribe(weak: self, onNext: { owner, _ in
            owner.navigateToAddContact?()
        }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else {fatalError("ViewModel is nil")}
        let contactsDriver = viewModel.contactsRelay.asDriver()
        contactsDriver.drive(contactsTableView.rx.items(cellType: ContactCell.self)) { indx, item, cell in
            cell.contact = item
        }.disposed(by: disposeBag)
    }
    
    private func tableCellDidSelected(at index: Int) {
        let element = viewModel?.contactsRelay.value[index]
        let alert = UIAlertController(title: element?.name, message: nil, preferredStyle: .actionSheet)
        
        let callAction = UIAlertAction(title: "Call", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Numbers", message: nil, preferredStyle: .actionSheet)
            element?.phoneNumbers?.map{ number in UIAlertAction(title: number, style: .default) { _ in
                UIApplication.shared.open(URL(string: "tel://\(number)")!)
            }}.forEach{
                alert.addAction($0)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        })
        
        let emailAction = UIAlertAction(title: "E-Mail", style: .default, handler: { _ in
            let alert = UIAlertController(title: "E-Mails", message: nil, preferredStyle: .actionSheet)
            element?.emails?.map{ email in UIAlertAction(title: email, style: .default) { _ in
                UIApplication.shared.open(URL(string: "mailto:\(email)")!)
            }}.forEach{
                alert.addAction($0)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(callAction)
        alert.addAction(emailAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, complete) in
            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
            complete(true)
        }
        let editButton = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, complete) in
            tableView.dataSource?.tableView!(tableView, commit: .insert, forRowAt: indexPath)
            complete(true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteButton, editButton])
        return swipeActions
    }
    
}




