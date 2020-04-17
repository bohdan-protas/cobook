//
//  ExpandableDescriptionTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ExpandableDescriptionTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var desctiptionTextView: DesignableTextView!
    @IBOutlet var desctiptionTextViewHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        desctiptionTextView.delegate = self
    }

    
}
