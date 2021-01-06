//
//  Reactive+UITableView.swift
//  iContacts
//
//  Created by Yousef on 1/5/21.
//

import RxSwift

extension Reactive where Base: UITableView {
    
    public func items<S: Sequence, Cell: UITableViewCell, O : ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable
        where O.E == S {
        self.items(cellIdentifier: String(describing: cellType), cellType: cellType)
    }
    
}
