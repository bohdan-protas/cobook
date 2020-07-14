//
//  ExpandableDescriptionTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

fileprivate enum Layout {
    static let trimmedStringMaxLength: Int = 100
}

protocol ExpandableDescriptionTableViewCellDelegate: class {
    func onExpandTapped(_ cell: ExpandableDescriptionTableViewCell)
}

class ExpandableDescriptionTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var desctiptionTextView: SelfSizingTextView!
    @IBOutlet var showMoreButton: UIButton!
    @IBOutlet var showMoreButtonHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: ExpandableDescriptionTableViewCellDelegate?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        desctiptionTextView.textContainer.lineFragmentPadding = 0
    }
    
    // MARK: - Actions
    
    @IBAction func showMoreButtonTapped(_ sender: Any) {
        delegate?.onExpandTapped(self)
    }
    
    
}
