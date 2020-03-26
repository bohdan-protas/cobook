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
    var source: [CreatePersonalCard.Section] = []

    unowned var tableView: UITableView
    weak var cellsDelegate: (TextViewTableViewCellDelegate &
                             TextFieldTableViewCellDelegate &
                             InterestsSelectionTableViewCellDelegate &
                             SocialsListTableViewCellDelegate)?

    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    subscript(indexPath: IndexPath) -> CreatePersonalCard.Item? {
        get {
            return source[safe: indexPath.section]?.items[safe: indexPath.row]
        }
        set(newValue) {
            source[safe: indexPath.section]?.items[safe: indexPath.row] = newValue
        }
    }

    // MARK: Lifecycle
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()

        tableView.dataSource = self
        tableView.register(SectionTitleTableViewCell.nib, forCellReuseIdentifier: SectionTitleTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.nib, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(TextViewTableViewCell.nib, forCellReuseIdentifier: TextViewTableViewCell.identifier)
        tableView.register(InterestsSelectionTableViewCell.nib, forCellReuseIdentifier: InterestsSelectionTableViewCell.identifier)
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

        case .textField(let text, let type):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = cellsDelegate
            cell.textTypeIdentifier = type.rawValue
            cell.textView.text = text
            cell.textView.placeholder = type.placeholder
            cell.textView.keyboardType = type.keyboardType
            cell.textView.reloadInputViews()
            return cell

        case .actionTextField(let text, let action):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = cellsDelegate
            cell.textView.text = text
            cell.textView.placeholder = action.placeholder
            cell.rightViewActionIdentifier = action.rawValue

            switch action {
            case .activityType(let list):
                pickerView.delegate = cell
                pickerView.dataSource = cell
                cell.pickerListDataSource = list.compactMap { $0.title }
                cell.textView.inputView = pickerView
            case .placeOfLiving, .activityRegion:
                cell.actionControlView.isUserInteractionEnabled = true
                cell.textView.isUserInteractionEnabled = false
            }
            return cell

        case .textView(let text, let type):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.delegate = cellsDelegate
            cell.textTypeIdentifier = type.rawValue
            cell.textView.placeholder = type.placeholder
            cell.textView.text = text
            return cell

        case .interests(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: InterestsSelectionTableViewCell.identifier, for: indexPath) as! InterestsSelectionTableViewCell
            cell.delegate = cellsDelegate
            cell.dataSource = list
            return cell

        case .socialList(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialsListTableViewCell.identifier, for: indexPath) as! SocialsListTableViewCell
            cell.delegate = cellsDelegate
            cell.fill(items: list, isEditable: true)
            return cell

        case .sectionHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionHeaderTableViewCell.identifier, for: indexPath) as! SectionHeaderTableViewCell
            return cell
        }


    }


}
