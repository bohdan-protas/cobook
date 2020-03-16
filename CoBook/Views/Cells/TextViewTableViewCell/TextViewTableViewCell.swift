//
//  TextViewTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol TextViewTableViewCellDelegate: class {
    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, textTypeIdentifier identifier: String?)
}

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet var textView: DesignableTextView!
    weak var delegate: TextViewTableViewCellDelegate?

    var textTypeIdentifier: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }


}

// MARK: - UITextViewDelegate
extension TextViewTableViewCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewTableViewCell(self, didUpdatedText: textView.text, textTypeIdentifier: textTypeIdentifier)
    }

}
