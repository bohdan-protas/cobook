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
    weak var cellsDelegate: (TextViewTableViewCellDelegate & TextFieldTableViewCellDelegate & InterestsSelectionTableViewCellDelegate)?

    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    subscript(indexPath: IndexPath) -> PersonalCard.Item? {
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

        case .textField(let type):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.textTypeIdentifier = type.rawValue
            cell.textView.placeholder = type.placeholder
            cell.textView.keyboardType = type.keyboardType
            cell.textView.reloadInputViews()
            return cell

        case .actionTextField(let action):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.textView.placeholder = action.placeholder
            cell.delegate = cellsDelegate
            cell.rightViewActionIdentifier = action.rawValue

            switch action {
            case .activityType(let list):
                pickerView.delegate = cell
                pickerView.dataSource = cell
                cell.pickerListDataSource = list.compactMap { $0.title }
                cell.textView.inputView = pickerView
            case .placeOfLiving:
                cell.actionControlView.isUserInteractionEnabled = true
                cell.textView.isUserInteractionEnabled = false
            }
            return cell

        case .textView(let type):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.textView.pText = type.placeholder
            cell.delegate = cellsDelegate
            return cell

        case .interests(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: InterestsSelectionTableViewCell.identifier, for: indexPath) as! InterestsSelectionTableViewCell
            cell.delegate = cellsDelegate
            cell.dataSource = list
            return cell
        }


    }


}
