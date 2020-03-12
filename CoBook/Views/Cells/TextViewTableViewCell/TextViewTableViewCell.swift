//
//  TextViewTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol TextViewTableViewCellDelegate: class {
    func didChangedText(_ cell: TextViewTableViewCell, updatedText text: String?, textTypeIdentifier identifier: String?)
}

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet var textView: DesignableTextView!
    weak var delegate: TextViewTableViewCellDelegate?

    var textTypeIdentifier: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        // Initialization code
    }


}

// MARK: - UITextViewDelegate
extension TextViewTableViewCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        delegate?.didChangedText(self, updatedText: textView.text, textTypeIdentifier: textTypeIdentifier)
    }

}
