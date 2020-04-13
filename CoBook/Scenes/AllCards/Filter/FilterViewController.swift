//
//  FilterViewController.swift
//  CoBook
//
//  Created by protas on 4/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// MARK: - Defaults

fileprivate enum Defaults {
    static let headerHeight: CGFloat = 49
    static var footerHeight: CGFloat = 16
}

// MARK: - FilterViewController

class FilterViewController: BaseViewController {

    enum SectionAccessoryIndex: Int {
        case interests
        case practicies
    }

    @IBOutlet var tableView: UITableView!
    
    var sections: [Section<FilterItemModel>] = []

    var savedFilters = AppStorage.User.Filters

    // MARK: - Actions

    @IBAction func closeButtonTapped(_ sender: Any) {

        // save selected filters to storage
        AppStorage.User.Filters?.interests = sections[safe: SectionAccessoryIndex.interests.rawValue]?.items.filter { $0.isSelected } ?? []
        AppStorage.User.Filters?.practicies = sections[safe: SectionAccessoryIndex.practicies.rawValue]?.items.filter { $0.isSelected } ?? []

        // dismiss controller
        dismiss(animated: true, completion: nil)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDataSource()
    }


}

// MARK: - TableViewDelegate

extension FilterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Defaults.headerHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FilterSectionHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: Defaults.headerHeight)))
        view.titleLabel.text = sections[section].title
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        sections[indexPath.section].items[indexPath.row].isSelected = true
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        sections[indexPath.section].items[indexPath.row].isSelected = false
    }


}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterItemTableViewCell.identifier, for: indexPath) as! FilterItemTableViewCell
        cell.titleLabel.text = sections[indexPath.section].items[indexPath.item].title
        cell.accessoryType = sections[indexPath.section].items[indexPath.row].isSelected ? .checkmark : .none
        return cell
    }


}

// MARK: - Privates

private extension FilterViewController {

    func setupLayout() {
        self.navigationItem.title = "Фільтри"

        tableView.register(FilterItemTableViewCell.nib, forCellReuseIdentifier: FilterItemTableViewCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self
    }

    func setupDataSource() {
        let group = DispatchGroup()

        var practicies: [FilterItemModel] = []
        var interests: [FilterItemModel] = []
        var errors: [Error] = []

        // fetch practices
        group.enter()
        APIClient.default.practicesTypesListRequest { (result) in
            switch result {
            case let .success(response):
                practicies = (response ?? []).compactMap { FilterItemModel(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                errors.append(error)
                group.leave()
            }
        }

        // fetch interests
        group.enter()
        APIClient.default.interestsListRequest { (result) in
            switch result {
            case let .success(response):
                interests = (response ?? []).compactMap { FilterItemModel(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                errors.append(error)
                group.leave()
            }
        }

        // setup data source
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }

            // show errors if necessary
            if !errors.isEmpty {
                errors.forEach { strongSelf.errorAlert(message: $0.localizedDescription) }
            }

            // setup selection filter selection state
            let fetchedInterests: [FilterItemModel] = interests.compactMap { fetched in
                let isSelected = strongSelf.savedFilters?.interests.contains(where: { (selected) -> Bool in
                    return selected.id == fetched.id
                })
                return FilterItemModel(id: fetched.id, title: fetched.title, isSelected: isSelected ?? false )
            }

            let fetchedPracticies: [FilterItemModel] = practicies.compactMap { fetched in
                let isSelected = strongSelf.savedFilters?.practicies.contains(where: { (selected) -> Bool in
                    return selected.id == fetched.id
                })
                return FilterItemModel(id: fetched.id, title: fetched.title, isSelected: isSelected ?? false )
            }

            // setup sections
            strongSelf.sections = [
                Section(accessoryIndex: SectionAccessoryIndex.interests.rawValue, title: "Інтереси", items: fetchedInterests),
                Section(accessoryIndex: SectionAccessoryIndex.practicies.rawValue, title: "Вид діяльності", items: fetchedPracticies)
            ]
            strongSelf.tableView.tableFooterView = CorneredEdgeView(frame: CGRect(origin: .zero, size: CGSize(width: strongSelf.tableView.frame.width, height: Defaults.footerHeight)))

            self?.tableView.reloadData()
        }
    }


}
