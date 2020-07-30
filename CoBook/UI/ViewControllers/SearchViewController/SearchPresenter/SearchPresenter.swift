//
//  SearchPresenter.swift
//  CoBook
//
//  Created by protas on 6/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: View -

protocol SearchView: class, AlertDisplayableView, LoadDisplayableView, NavigableView {
    func set(searchBarText: String?)
    func set(dataSource: TableDataSource<SearchCellsConfigurator>?)
    func reload()
}

// MARK: Presenter -

protocol SearchPresenter: class {
    var view: SearchView? { get set }
    var isMultiselectEnabled: Bool { get }
    func setup()
    func prepareForDismiss()
    func searchBy(text: String?)
    func selectedAt(indexPath: IndexPath, completion: ((Bool) -> Void)?)
    func deselectedAt(indexPath: IndexPath, completion: ((Bool) -> Void)?)
}
