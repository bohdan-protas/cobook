//
//  FilterPresenter.swift
//  CoBook
//
//  Created by protas on 6/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol FilterView: class, LoadDisplayableView, AlertDisplayableView {
    func set(tableDataSource: DataSource<FilterCellsConfigurator>?)
    func reload()
    func showSearchPracticies(presenter: SearchPracticiesPresenter)
}

class FilterPresenter: BasePresenter {

    weak var view: FilterView?

    private var tableDataSource: DataSource<FilterCellsConfigurator>?
    private var fetchedPracticies: [PracticeModel] = []

    // MARK: - Initialized

    init() {
        tableDataSource = DataSource()
        tableDataSource?.sections = [Section<Filter.Items>(accessoryIndex: Filter.SectionAccessoryIndex.interests.rawValue, items: []),
                                     Section<Filter.Items>(accessoryIndex: Filter.SectionAccessoryIndex.practicies.rawValue, items: [])]
        tableDataSource?.configurator = tableDataSourceConfigurator
    }

    // MARK: - Public

    func attachView(_ view: FilterView) {
        self.view = view
        self.view?.set(tableDataSource: tableDataSource)
    }

    func detachView() {
        self.view = nil
    }

    func setup() {
        fetchedPracticies = AppStorage.User.Filters?.practicies ?? []
        updateViewDataSource()
        view?.reload()
    }

    func save() {
        AppStorage.User.Filters?.practicies = fetchedPracticies.filter { $0.isSelected }
    }


}

// MARK: - Privates

private extension FilterPresenter {

    func updateViewDataSource() {
        tableDataSource?.sections[Filter.SectionAccessoryIndex.practicies.rawValue].items = [
            .title(model: ActionTitleModel(title: "Filter.section.practicies.title".localized,
                                           counter: fetchedPracticies.count,
                                           actionTitle: "Button.edit.normalTitle".localized, actionHandler: {

                                            let presenter = SearchPracticiesPresenter(isMultiselectEnabled: true)
                                            presenter.delegate = self
                                            self.view?.showSearchPracticies(presenter: presenter)

            })),
            .itemsPreview(dataSourceID: nil),
        ]
    }


}

// MARK: - InterestsSelectionTableViewCellDataSource, InterestsSelectionTableViewCellDelegate

extension FilterPresenter: InterestsSelectionTableViewCellDataSource, InterestsSelectionTableViewCellDelegate {

    func dataSourceWith(identifier: String?) -> [InterestModel] {
        return fetchedPracticies.compactMap { InterestModel(id: $0.id, title: $0.title, isSelected: $0.isSelected) }
    }

    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didSelectInterestAt index: Int) {
        fetchedPracticies[safe: index]?.isSelected = true
    }

    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didDeselectInterestAt index: Int) {
        fetchedPracticies[safe: index]?.isSelected = false
    }


}

// MARK: - SearchPracticiesDelegate

extension FilterPresenter: SearchPracticiesDelegate {

    func didSelectedPractices(_ models: [PracticeModel]) {
        fetchedPracticies = models
        updateViewDataSource()
        view?.reload()
    }


}

