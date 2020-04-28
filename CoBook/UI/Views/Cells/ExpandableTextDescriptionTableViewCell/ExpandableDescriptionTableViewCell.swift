//
//  ExpandableDescriptionTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ExpandableDescriptionTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var desctiptionTextView: SelfSizingTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        desctiptionTextView.delegate = self
        desctiptionTextView.textContainer.lineFragmentPadding = 0
    }

    
}
