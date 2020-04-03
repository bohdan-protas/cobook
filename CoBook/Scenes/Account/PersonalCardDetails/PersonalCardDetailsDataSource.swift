//
//  PersonalCardDetailsDataSource.swift
//  CoBook
//
//  Created by protas on 3/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class PersonalCardDetailsDataSource: NSObject, UITableViewDataSource {

    // MARK: Properties
    unowned var tableView: UITableView
    weak var cellsDelegate: (SocialsListTableViewCellDelegate & GetInTouchTableViewCellDelegate)?

    // MARK: Source
    var source: [PersonalCardDetails.Section] = []

    subscript(section: Int) -> PersonalCardDetails.Section? {
        get {
            return source[safe: section]
        }
        set(newValue) {
            source[safe: section] = newValue
        }
    }

    subscript(item: IndexPath) -> PersonalCardDetails.Item? {
        get {
            return source[safe: item.section]?.items[safe: item.row]
        }
        set(newValue) {
            source[safe: item.section]?.items[safe: item.row] = newValue
        }
    }

    // MARK: Lifecycle
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()

        tableView.dataSource = self
        tableView.register(SectionTitleTableViewCell.nib, forCellReuseIdentifier: SectionTitleTableViewCell.identifier)
        tableView.register(PersonalCardUserInfoTableViewCell.nib, forCellReuseIdentifier: PersonalCardUserInfoTableViewCell.identifier)
        tableView.register(GetInTouchTableViewCell.nib, forCellReuseIdentifier: GetInTouchTableViewCell.identifier)
        tableView.register(SocialsListTableViewCell.nib, forCellReuseIdentifier: SocialsListTableViewCell.identifier)
        tableView.register(SectionHeaderTableViewCell.nib, forCellReuseIdentifier: SectionHeaderTableViewCell.identifier)
    }

    // MARK:  UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return source[safe: section]?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataType = source[safe: indexPath.section]?.items[safe: indexPath.item] else {
            return UITableViewCell()
        }

        switch dataType {
        case .title(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionTitleTableViewCell.identifier, for: indexPath) as! SectionTitleTableViewCell
            cell.titleLabel.text = text
            return cell
        case .userInfo(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: PersonalCardUserInfoTableViewCell.identifier, for: indexPath) as! PersonalCardUserInfoTableViewCell
            //cell.fill(with: data)
            return cell
        case .getInTouch:
            let cell = tableView.dequeueReusableCell(withIdentifier: GetInTouchTableViewCell.identifier, for: indexPath) as! GetInTouchTableViewCell
            cell.delegate = cellsDelegate
            return cell
        case .socialList(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialsListTableViewCell.identifier, for: indexPath) as! SocialsListTableViewCell
            cell.delegate = cellsDelegate
            //cell.fill(items: list, isEditable: false)
            return cell
        case .sectionHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionHeaderTableViewCell.identifier, for: indexPath) as! SectionHeaderTableViewCell
            return cell
        }
    }


}
