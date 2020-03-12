//
//  TextFieldTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    func didChangedText(_ cell: TextFieldTableViewCell, updatedText text: String?, textTypeIdentifier identifier: String?)
    func didOccuredAction(_ cell: TextFieldTableViewCell, actionIdentifier identifier: String?)
}

class TextFieldTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet var textView: DesignableTextField!
    weak var delegate: TextFieldTableViewCellDelegate?

    // MARK: Properties
    var textTypeIdentifier: String?
    var rightViewActionIdentifier: String? {
        didSet {
            textView.rightViewMode = rightViewActionIdentifier == nil ? .never : .always
        }
    }

    private lazy var rightViewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_arrow_bottom"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 16)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.rightView = rightViewButton
    }

    // MARK: Actions
    @IBAction func textViewEditingChanged(_ sender: UITextField) {
        delegate?.didChangedText(self, updatedText: sender.text, textTypeIdentifier: textTypeIdentifier)
    }

    @objc func actionButtonTapped() {
        guard let rightViewActionIdentifier = rightViewActionIdentifier else {
            return
        }
        delegate?.didOccuredAction(self, actionIdentifier: rightViewActionIdentifier)
    }


    
}
