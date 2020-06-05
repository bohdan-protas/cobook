//
//  SearchPresenter.swift
//  CoBook
//
//  Created by protas on 6/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: View -

protocol SearchView: class, AlertDisplayableView, LoadDisplayableView {
    var isSearching: Bool { get }
    func set(dataSource: DataSource<SearchCellsConfigurator>?)
    func reload()
}

// MARK: Presenter -

protocol SearchPresenter: class {
    var view: SearchView? { get set }
    func setup()
    func searchBy(text: String?)
}
