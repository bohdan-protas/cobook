//
//  SearchPracticiesPresenter.swift
//  CoBook
//
//  Created by protas on 6/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SearchPracticiesDelegate: class {
    func didSelectedPractices(_ models: [PracticeModel])

}

class SearchPracticiesPresenter: SearchPresenter {

    weak var view: SearchView?
    weak var delegate: SearchPracticiesDelegate?
    private var viewDataSource: DataSource<SearchCellsConfigurator>?

    private var practicies: [PracticeModel] = []
    private var filteredPracticies: [PracticeModel] = []

    var isMultiselectEnabled: Bool

    var selectionCompletion: ((_ practice: PracticeModel?) -> Void)?

    // MARK: - Search presenter

    init(isMultiselectEnabled: Bool) {
        self.isMultiselectEnabled = isMultiselectEnabled
        var configurator = SearchCellsConfigurator()
        configurator.practiceConfigurator = CellConfigurator(configurator: { (cell, model: PracticeModel, tableView, index) -> FilterItemTableViewCell in
            cell.titleLabel?.text = model.title
            cell.isSelected = model.isSelected
            return cell
        })
        self.viewDataSource = DataSource(sections: [], configurator: configurator)
    }

    func setup() {
        fetchPracticies()
        view?.set(dataSource: viewDataSource)
    }

    func searchBy(text: String?) {
        guard let text = text, !text.isEmpty else {
            filteredPracticies = practicies
            updateViewDataSource()
            view?.reload()
            return
        }

        filteredPracticies = practicies.filter { ($0.title ?? "").lowercased().contains(text.lowercased()) }
        updateViewDataSource()
        view?.reload()
    }

    func selectedAt(indexPath: IndexPath) {
        filteredPracticies[indexPath.item].isSelected = true
        if let index = practicies.firstIndex(where: { $0.id == filteredPracticies[safe: indexPath.item]?.id }) {
            practicies[safe: index]?.isSelected = true
            selectionCompletion?(practicies[safe: index])
        }
    }

    func deselectedAt(indexPath: IndexPath) {
        filteredPracticies[indexPath.item].isSelected = false
        if let index = practicies.firstIndex(where: { $0.id == filteredPracticies[safe: indexPath.item]?.id }) {
            practicies[safe: index]?.isSelected = false
        }
    }

    func prepareForDismiss() {
        let selected = practicies.filter { $0.isSelected }
        delegate?.didSelectedPractices(selected)
    }


}

// MARK: - View updating

extension SearchPracticiesPresenter {

    func updateViewDataSource() {
        let photosSection = Section<SearchContent.Item>(items: filteredPracticies.compactMap { .practice(model: $0) })
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
                self.filteredPracticies = self.practicies
                self.updateViewDataSource()
                self.view?.reload()
            case let .failure(error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}
