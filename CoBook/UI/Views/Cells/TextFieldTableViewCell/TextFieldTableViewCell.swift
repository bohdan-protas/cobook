//
//  TextFieldTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?)
}

extension TextFieldTableViewCellDelegate {
    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {}
}

protocol TextFieldTableViewCellDataSource: class {
    var pickerList: [String] { get }
}

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet var textField: DesignableTextField!
    @IBOutlet var actionControlView: UIControl!

    /// Data source&actions delegation
    weak var delegate: TextFieldTableViewCellDelegate?
    weak var dataSource: TextFieldTableViewCellDataSource?

    /// right arrow view
    private lazy var arrowRightView: UIView = {
        let iconView = UIImageView(frame: CGRect(x: -15, y: 0, width: 10, height: 10))
        iconView.image = UIImage(named: "ic_arrow_bottom")
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        iconContainerView.addSubview(iconView)
        return iconContainerView
    }()

    /// picker for list datasource
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    /// associated text key path
    var textKeyPath: AnyKeyPath?

    /// associated action identifier
    var actionIdentifier: String? {
        didSet {
            textField.rightViewMode = actionIdentifier == nil ? .never : .always
        }
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.rightView = arrowRightView
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = ""
        textField.placeholder = ""
        actionIdentifier = nil
        textKeyPath = nil
        actionControlView.isUserInteractionEnabled = false
        textField.isUserInteractionEnabled = true
    }

    // MARK: - Actions

    @IBAction func textViewEditingChanged(_ sender: UITextField) {
        delegate?.textFieldTableViewCell(self, didUpdatedText: sender.text, forKeyPath: textKeyPath)
    }

    @IBAction func actionControlViewDidTapped(_ sender: Any) {
        delegate?.textFieldTableViewCell(self, didOccuredAction: actionIdentifier)
    }


}

// MARK: - UIPickerViewDelegate Delegation

extension TextFieldTableViewCell: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = dataSource?.pickerList[safe: row]
        delegate?.textFieldTableViewCell(self, didOccuredAction: actionIdentifier)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource?.pickerList[safe: row]
    }


}

// MARK: - UIPickerViewDataSource Delegation

extension TextFieldTableViewCell: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.pickerList.count ?? 0
    }


}
