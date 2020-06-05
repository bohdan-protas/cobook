//
//  SearchPracticiesPresenter.swift
//  CoBook
//
//  Created by protas on 6/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SearchPracticiesPresenter: SearchPresenter {

    weak var view: SearchView?
    private var viewDataSource: DataSource<SearchCellsConfigurator>?
    private var practicies: [PracticeModel] = []

    /// Current search request
    private var pendingRequestWorkItem: DispatchWorkItem?

    // MARK: - Search presenter

    init() {
        var configurator = SearchCellsConfigurator()
        configurator.practiceConfigurator = CellConfigurator(configurator: { (cell, model: PracticeModel, tableView, index) -> UITableViewCell in
            cell.textLabel?.text = model.title
            return cell
        })
        self.viewDataSource = DataSource(sections: [], configurator: configurator)
    }

    func setup() {
        fetchPracticies()
    }

    func searchBy(text: String?) {

    }


}

// MARK: - View updating

extension SearchPracticiesPresenter {

    func updateViewDataSource() {
        let photosSection = Section<SearchContent.Item>(items: practicies.compactMap {  .practice(model: $0) })
        viewDataSource?.sections = [photosSection]
    }

}

// MARK: - Privates

private extension SearchPracticiesPresenter {

    func fetchPracticies() {
        APIClient.default.practicesTypesListRequest { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.practicies = (response ?? []).compactMap { PracticeModel(id: $0.id, title: $0.title) }
                self.updateViewDataSource()
                self.view?.reload()
            case let .failure(error):
                break
            }
        }
    }


}
