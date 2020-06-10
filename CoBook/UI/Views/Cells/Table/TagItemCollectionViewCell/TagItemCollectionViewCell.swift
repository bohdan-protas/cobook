//
//  InterestItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 3/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

fileprivate enum Layout {
    static let selectedBgColor: UIColor = #colorLiteral(red: 0.4823529412, green: 0.7333333333, blue: 0.368627451, alpha: 1)
    static let deselectedBgColor: UIColor = #colorLiteral(red: 0.9647058824, green: 1, blue: 0.9490196078, alpha: 1)
    static let selectedButtonColor: UIColor = #colorLiteral(red: 0.9647058824, green: 1, blue: 0.9490196078, alpha: 1)
    static let deselectedButtonColor: UIColor = #colorLiteral(red: 0.4823529412, green: 0.7333333333, blue: 0.368627451, alpha: 1)
    static let selectedTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let deselectedTextColor: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
}

class TagItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerView: DesignableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var actionButton: UIButton!

    @IBOutlet var labelWidthConstraint: NSLayoutConstraint!
    @IBOutlet var maxWidthConstraint: NSLayoutConstraint!
    @IBOutlet var labelHeightConstraint: NSLayoutConstraint!
    
    func setSelected(_ isSelected: Bool) {
        containerView.backgroundColor = isSelected ? Layout.selectedBgColor : Layout.deselectedBgColor
        titleLabel.textColor = isSelected ? Layout.selectedTextColor : Layout.deselectedTextColor
        actionButton.tintColor = isSelected ? Layout.selectedButtonColor : Layout.deselectedButtonColor

        UIView.animate(withDuration: 0.1) {
            self.actionButton.transform = isSelected ? CGAffineTransform(rotationAngle: CGFloat.pi / 4) : CGAffineTransform.identity
        }
    }


}
