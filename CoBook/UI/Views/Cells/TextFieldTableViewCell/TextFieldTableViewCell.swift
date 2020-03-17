//
//  TextFieldTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, textTypeIdentifier identifier: String?)
    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?)
}

class TextFieldTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet var textView: DesignableTextField!
    @IBOutlet var actionControlView: UIControl!

    private lazy var rightView: UIView = {
        let iconView = UIImageView(frame: CGRect(x: -15, y: 0, width: 10, height: 10))
        iconView.image = UIImage(named: "ic_arrow_bottom")
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        iconContainerView.addSubview(iconView)

        return iconContainerView
    }()

    weak var delegate: TextFieldTableViewCellDelegate?

    var pickerListDataSource: [String] = []
    var textTypeIdentifier: String?
    var rightViewActionIdentifier: String? {
        didSet {
            textView.rightViewMode = rightViewActionIdentifier == nil ? .never : .always
        }
    }

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.rightView = rightView
    }

    // MARK: Actions
    @IBAction func textViewEditingChanged(_ sender: UITextField) {
        delegate?.textFieldTableViewCell(self, didUpdatedText: sender.text, textTypeIdentifier: textTypeIdentifier)
    }

    @IBAction func actionControlViewDidTapped(_ sender: Any) {
        guard let rightViewActionIdentifier = rightViewActionIdentifier else {
            return
        }
        delegate?.textFieldTableViewCell(self, didOccuredAction: rightViewActionIdentifier)
    }

    
}

// MARK: - UIPickerViewDelegate Delegation
extension TextFieldTableViewCell: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textView.text = pickerListDataSource[safe: row]
        delegate?.textFieldTableViewCell(self, didOccuredAction: rightViewActionIdentifier)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerListDataSource[safe: row]
    }


}

// MARK: - UIPickerViewDataSource Delegation
extension TextFieldTableViewCell: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerListDataSource.count
    }


}
