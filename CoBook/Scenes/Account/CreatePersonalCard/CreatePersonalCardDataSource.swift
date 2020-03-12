//
//  CreatePersonalCardDataSource.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CreatePersonalCardDataSource: NSObject, UITableViewDataSource {

    // MARK: Properties
    var source: [PersonalCard.Section] = []

    unowned var tableView: UITableView
    weak var cellsDelegate: (TextViewTableViewCellDelegate & TextFieldTableViewCellDelegate)?

    // MARK: Lifecycle
    init(tableView: UITableView, source: [PersonalCard.Section] = []) {
        self.source = source
        self.tableView = tableView
        super.init()

        tableView.dataSource = self
        tableView.register(SectionTitleTableViewCell.nib, forCellReuseIdentifier: SectionTitleTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.nib, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(TextViewTableViewCell.nib, forCellReuseIdentifier: TextViewTableViewCell.identifier)
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

        case .textField(let type, let action):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.textTypeIdentifier = type.rawValue
            cell.rightViewActionIdentifier = action?.rawValue
            cell.textView.placeholder = type.placeholder
            cell.delegate = cellsDelegate
            return cell

        case .textView(let type):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.textView.pText = type.placeholder
            cell.delegate = cellsDelegate
            return cell
        }

    }


}
