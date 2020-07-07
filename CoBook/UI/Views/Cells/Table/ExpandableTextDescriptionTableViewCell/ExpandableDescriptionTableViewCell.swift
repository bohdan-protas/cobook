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
    
    private var originalDescrText: String = ""
    
    weak var delegate: ExpandableDescriptionTableViewCellDelegate?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        desctiptionTextView.textContainer.lineFragmentPadding = 0
    }
    
    // MARK: - Actions
    
    @IBAction func showMoreButtonTapped(_ sender: Any) {
        desctiptionTextView.text = originalDescrText
        delegate?.onExpandTapped(self)
    }
    
    // MARK: - Public
    
    func set(descriptionText: String, useCollaping: Bool = false) {
        switch useCollaping {
        case true:
            if descriptionText.count > Layout.trimmedStringMaxLength {
                originalDescrText = descriptionText
                let trimmedText = descriptionText
                    .prefix(Layout.trimmedStringMaxLength)
                    .appending("...")
                desctiptionTextView.text = trimmedText
                showMoreButton.isHidden = false
                showMoreButtonHeightConstraint.constant = 50
                break
            }
            fallthrough
        case false:
            desctiptionTextView.text = descriptionText
            showMoreButton.isHidden = true
            showMoreButtonHeightConstraint.constant = 0
        }
    }

    
}
