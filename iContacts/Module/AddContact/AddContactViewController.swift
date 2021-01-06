//
//  AddContactViewController.swift
//  iContacts
//
//  Created by Yousef on 1/4/21.
//

import UIKit
import RxSwift

class AddContactViewController: ViewController<AddContactViewModel> {
    
    deinit {
        print("\(self) deinit")
    }
    
    //MARK: - Variables
    @IBOutlet private weak var nameTF: TextField!
    @IBOutlet private weak var numbersTable: UITableView!
    @IBOutlet private weak var numberTableHeight: NSLayoutConstraint!
    @IBOutlet private weak var addNumberBtn: UIButton!
    @IBOutlet private weak var emailsTable: UITableView!
    @IBOutlet private weak var emailsTableHeight: NSLayoutConstraint!
    @IBOutlet private weak var addEmailBtn: UIButton!
    @IBOutlet private weak var doneBtn: Button!
    @IBOutlet private weak var cancelBtn: Button!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTables()
        setupButtonsActions()
        bindViewModel()
    }
    
    // MARK: - Private Functions
    private func setupTables() {
        numbersTable.register(cellClass: InputCell.self)
        emailsTable.register(cellClass: InputCell.self)
        
        let numbersDriver = viewModel!.numbersRelay.asDriver()
        numbersDriver.drive(numbersTable.rx.items(cellType: InputCell.self)){ [unowned self] indx, item, cell in
            self.viewModel!.setupNumberTableCell(cell, index: indx)
        }.disposed(by: disposeBag)
        viewModel!.numbersTableHeightDriver.drive(numberTableHeight.rx.constant).disposed(by: disposeBag)
        
        let emailsDriver = viewModel!.emailsRelay.asDriver()
        emailsDriver.drive(emailsTable.rx.items(cellType: InputCell.self)){ [unowned self] indx, item, cell in
            self.viewModel!.setupEmailTableCell(cell, index: indx)
        }.disposed(by: disposeBag)
        viewModel!.emailsTableHeightDriver.drive(emailsTableHeight.rx.constant).disposed(by: disposeBag)
    }
    
    private func setupButtonsActions() {
        
        addNumberBtn.rx.tap.subscribe(weak: self, onNext: { owner, _ in
            owner.viewModel?.addNumberBtnTapped()
        }).disposed(by: disposeBag)
        
        addEmailBtn.rx.tap.subscribe(weak: self, onNext: { owner, _ in
            owner.viewModel?.addEmailBtnTapped()
        }).disposed(by: disposeBag)
        
        doneBtn.rx.tap.flatMap { [unowned self] in
            self.viewModel!.doneBtnTapped()
        }.subscribeOn(MainScheduler.instance).subscribe(weak: self, onNext: { owner, _ in
            owner.displaySuccessHUD() {
                owner.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
        
        cancelBtn.rx.tap.subscribe(weak: self, onNext: { owner, _ in
            owner.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    private func bindViewModel() {
        viewModel!.nameRelay.asDriver().drive(nameTF.rx.text).disposed(by: disposeBag)
        nameTF.rx.text.orEmpty.bind(to: viewModel!.nameRelay).disposed(by: disposeBag)
    }
    
}

extension ObservableType {
    
    func subscribe<Owner: AnyObject>(weak owner: Owner,
                                     onNext: ((Owner, Self.E)-> Void)? = nil,
                                     onError: ((Owner, Error)-> Void)? = nil)-> Disposable {
        return self.subscribe(onNext: { [weak owner] val in
            guard let owner = owner else {return}
            onNext?(owner, val)
        }, onError: { [weak owner] err in
            guard let owner = owner else {return}
            onError?(owner, err)
        }, onDisposed:  {
//            print("Disposed")
        })
    }
    
}
