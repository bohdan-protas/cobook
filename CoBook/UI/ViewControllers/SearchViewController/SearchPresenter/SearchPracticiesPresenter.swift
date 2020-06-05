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
    private var filteredPracticies: [PracticeModel] = []

    /// Current search request

    // MARK: - Search presenter

    init() {
        var configurator = SearchCellsConfigurator()
        configurator.practiceConfigurator = CellConfigurator(configurator: { (cell, model: PracticeModel, tableView, index) -> FilterItemTableViewCell in
            cell.titleLabel?.text = model.title
            cell.accessoryType = model.isSelected ? .checkmark : .none
            return cell
        })
        self.viewDataSource = DataSource(sections: [], configurator: configurator)
    }

    func setup() {
        fetchPracticies()
        view?.set(dataSource: viewDataSource)
    }

    func searchBy(text: String?) {
        filteredPracticies = practicies.filter { ($0.title ?? "").lowercased().contains((text ?? "").lowercased()) }
        updateViewDataSource()
        view?.reload()
    }


}

// MARK: - View updating

extension SearchPracticiesPresenter {

    func updateViewDataSource() {
        let items: [SearchContent.Item] = view?.isSearching ?? false ?
            filteredPracticies.compactMap { .practice(model: $0) } :
            practicies.compactMap { .practice(model: $0) }

        let photosSection = Section<SearchContent.Item>(items: items)
        viewDataSource?.sections = [photosSection]
    }

}

// MARK: - Privates

private extension SearchPracticiesPresenter {

    func fetchPracticies() {
        view?.startLoading()
        APIClient.default.practicesTypesListRequest { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case let .success(response):
                self.practicies = (response ?? []).compactMap { PracticeModel(id: $0.id, title: $0.title) }
                self.updateViewDataSource()
                self.view?.reload()
            case let .failure(error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}
