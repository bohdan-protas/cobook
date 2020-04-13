//
//  FilterViewController.swift
//  CoBook
//
//  Created by protas on 4/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct FilterItemModel {
    var id: Int?
    var title: String?
}

private enum Defaults {
    static let headerHeight: CGFloat = 49
}

class FilterViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    
    var sections: [Section<FilterItemModel>] = []

    // MARK: - Actions

    @IBAction func closeButtonTapped(_ sender: Any) {
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

            if !errors.isEmpty {
                errors.forEach { strongSelf.errorAlert(message: $0.localizedDescription) }
            }

            strongSelf.sections = [Section(title: "Інтереси", items: interests), Section(title: "Вид діяльності", items: practicies)]
            strongSelf.tableView.tableFooterView = CorneredEdgeView(frame: CGRect(origin: .zero, size: CGSize(width: strongSelf.tableView.frame.width, height: 16)))

            self?.tableView.reloadData()
        }
    }


}
