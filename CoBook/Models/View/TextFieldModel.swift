//
//  TextFieldModel.swift
//  CoBook
//
//  Created by protas on 3/31/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CellConfigurator {
    associatedtype Cell: UITableViewCell
    associatedtype Model
    func configure(cell: Cell, with model: Model)
}

struct TextInputTableViewCellCellConfigurator<Model>: CellConfigurator {
    let textKeyPath: KeyPath<Model, String>
    let placeholderKeyPath: KeyPath<Model, String>
    let keyboardTypeKeyPath: KeyPath<Model, UIKeyboardType>

    func configure(cell: TextFieldTableViewCell, with model: Model) {
        cell.textView.text = model[keyPath: textKeyPath]
        cell.textView.placeholder = model[keyPath: placeholderKeyPath]
        cell.textView.keyboardType = model[keyPath: keyboardTypeKeyPath]
    }

}
