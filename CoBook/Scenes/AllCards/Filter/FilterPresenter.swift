//
//  FilterPresenter.swift
//  CoBook
//
//  Created by protas on 6/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol FilterView: class, LoadDisplayableView, AlertDisplayableView {
    func set(collectionDataSource: CollectionDataSource<FilterCellsConfigurator>?)
    func reload()
    func showSearchPracticies(presenter: SearchPracticiesPresenter)
}

class FilterPresenter: BasePresenter {

    weak var view: FilterView?

    private var collectionDataSource: CollectionDataSource<FilterCellsConfigurator>?
    private var fetchedPracticies: [PracticeModel] = []

    private var filterCellsConfigurator: FilterCellsConfigurator {
        get {

            let titleConfigurator = CollectionCellConfigurator { (cell, model: ActionTitleModel, collectionView, indexPath) -> ActionTitleCollectionViewCell in
                cell.titleLabel.text = model.title
                cell.countLabel.text = "\( model.counter ?? 0)"
                cell.actionButton.setTitle(model.actionTitle, for: .normal)
                cell.actionHandler = model.actionHandler
                return cell
            }

            let practiceFilterItemConfigurator = CollectionCellConfigurator { (cell, model: PracticeModel, collectionView, indexPath) -> TagItemCollectionViewCell in
                cell.titleLabel.text = model.title
                cell.setSelected(model.isSelected)
                cell.maxWidthConstraint.constant = collectionView.frame.width
                cell.labelWidthConstraint.constant = model.title?.width(withConstrainedHeight: 24, font: UIFont.SFProDisplay_Regular(size: 14)) ?? 0
                return cell
            }

            return FilterCellsConfigurator(actionTitleConfigurator: titleConfigurator, practiceFilterItemConfigurator: practiceFilterItemConfigurator)
        }
    }

    // MARK: - Initialized

    init() {
        collectionDataSource = CollectionDataSource()
        collectionDataSource?.configurator = filterCellsConfigurator
    }

    // MARK: - Public

    func attachView(_ view: FilterView) {
        self.view = view
        self.view?.set(collectionDataSource: collectionDataSource)
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

    func selectedItem(cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch collectionDataSource?.sections[indexPath.section].items[indexPath.item] {
        case .none: break
        case .some(let item):
            switch item {
            case .practiceItem(let model):
                if let index = fetchedPracticies.firstIndex(where: { $0.id == model.id }) {
                    fetchedPracticies[index].isSelected.toggle()
                }
                var model = model
                model.isSelected.toggle()
                (cell as? TagItemCollectionViewCell)?.setSelected(model.isSelected)
                collectionDataSource?.sections[indexPath.section].items[indexPath.item] = .practiceItem(model: model)
            default: break
            }
        }
    }

    func sizeForItemAt(indexPath: IndexPath, for viewRect: CGRect) -> CGSize {
        let item = collectionDataSource?.sections[indexPath.section].items[indexPath.item]
        switch item {
        case .none:
            return .zero
        case .some(let item):
            switch item {
            case .title:
                return CGSize(width: viewRect.width, height: 50)
            case .practiceItem:
                return CGSize(width: viewRect.width, height: 24)
            }
        }
    }


}

// MARK: - Privates

private extension FilterPresenter {

    func updateViewDataSource() {

        let interestsSection = Section<Filter.Items>(accessoryIndex: Filter.SectionAccessoryIndex.interests.rawValue, items: [])
        var practiceSection = Section<Filter.Items>(accessoryIndex: Filter.SectionAccessoryIndex.practicies.rawValue, items: [])

        practiceSection.items.append(.title(model: ActionTitleModel(title: "Filter.section.practicies.title".localized, counter: fetchedPracticies.count, actionTitle: "Button.addFilter.normalTitle".localized, actionHandler: {
            let presenter = SearchPracticiesPresenter(isMultiselectEnabled: true, selectedPracticies: self.fetchedPracticies.filter {$0.isSelected})
            presenter.delegate = self
            self.view?.showSearchPracticies(presenter: presenter)
        })))
        practiceSection.items.append(contentsOf: fetchedPracticies.compactMap { Filter.Items.practiceItem(model: $0) })

        collectionDataSource?.sections = [interestsSection, practiceSection]
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

