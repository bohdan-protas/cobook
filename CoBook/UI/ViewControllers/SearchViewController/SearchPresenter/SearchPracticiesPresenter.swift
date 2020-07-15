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
    private var viewDataSource: TableDataSource<SearchCellsConfigurator>?

    private var practicies: [PracticeModel] = []
    private var filteredPracticies: [PracticeModel] = []
    private var selectedPracticies: [PracticeModel] = []

    var isMultiselectEnabled: Bool
    var selectionCompletion: ((_ practice: PracticeModel?) -> Void)?

    // MARK: - Search presenter

    init(isMultiselectEnabled: Bool, selectedPracticies: [PracticeModel] = []) {
        self.isMultiselectEnabled = isMultiselectEnabled
        self.selectedPracticies = selectedPracticies
        var configurator = SearchCellsConfigurator()
        configurator.practiceConfigurator = TableCellConfigurator(configurator: { (cell, model: PracticeModel, tableView, index) -> FilterItemTableViewCell in
            cell.titleLabel?.text = model.title
            cell.isSelected = model.isSelected
            return cell
        })
        self.viewDataSource = TableDataSource(sections: [], configurator: configurator)
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

    func prepareForDismiss() {
        let selected = practicies.filter { $0.isSelected }
        delegate?.didSelectedPractices(selected)
    }

    func selectedAt(indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        let count = practicies.filter { $0.isSelected }.count
        if count == 10 {
            view?.errorAlert(message: String(format: "Error.maxSelectedElements".localized, 10))
            return
        }

        filteredPracticies[indexPath.item].isSelected = true
        if let index = practicies.firstIndex(where: { $0.id == filteredPracticies[safe: indexPath.item]?.id }) {
            practicies[safe: index]?.isSelected = true
            selectionCompletion?(practicies[safe: index])
            completion?(true)
        }
    }

    func deselectedAt(indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        filteredPracticies[indexPath.item].isSelected = false
        if let index = practicies.firstIndex(where: { $0.id == filteredPracticies[safe: indexPath.item]?.id }) {
            practicies[safe: index]?.isSelected = false
            completion?(true)
        }
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
                self.practicies = self.practicies.compactMap { fetched in
                    let isSelected: Bool = self.selectedPracticies.compactMap{ $0.id }.contains(fetched.id ?? -1)
                    return PracticeModel(id: fetched.id, title: fetched.title, isSelected: isSelected)
                }
                self.practicies.sort { (a, b) -> Bool in
                    let titleOne = a.title ?? ""
                    let titleTwo = b.title ?? ""
                    return titleOne.localizedCaseInsensitiveCompare(titleTwo) == .orderedAscending
                }
                self.filteredPracticies = self.practicies
                self.updateViewDataSource()
                self.view?.reload()
            case let .failure(error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}
