//
//  InterestItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 3/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class InterestItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerView: DesignableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var actionButton: UIButton!

    private var selectedBgColor: UIColor = #colorLiteral(red: 0.4823529412, green: 0.7333333333, blue: 0.368627451, alpha: 1)
    private var deselectedBgColor: UIColor = #colorLiteral(red: 0.9647058824, green: 1, blue: 0.9490196078, alpha: 1)
    private var selectedButtonColor: UIColor = #colorLiteral(red: 0.9647058824, green: 1, blue: 0.9490196078, alpha: 1)
    private var deselectedButtonColor: UIColor = #colorLiteral(red: 0.4823529412, green: 0.7333333333, blue: 0.368627451, alpha: 1)
    private var selectedTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private var deselectedTextColor: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)

    var maxWidth: CGFloat?

    //forces the system to do one layout pass
    var isSizeCalculated: Bool = false
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        //Exhibit A - We need to cache our calculation to prevent a crash.
        if !isSizeCalculated {
            setNeedsLayout()
            layoutIfNeeded()

            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            if let maxWidth = maxWidth {
                newFrame.size.width = min(CGFloat(ceilf(Float(size.width))), maxWidth)
            } else {
                newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            }

            layoutAttributes.frame = newFrame
            isSizeCalculated = true
        }
        return layoutAttributes
    }

    func setSelected(_ isSelected: Bool) {
        containerView.backgroundColor = isSelected ? selectedBgColor : deselectedBgColor
        titleLabel.textColor = isSelected ? selectedTextColor : deselectedTextColor
        actionButton.tintColor = isSelected ? selectedButtonColor : deselectedButtonColor

        UIView.animate(withDuration: 0.1) {
            self.actionButton.transform = isSelected ? CGAffineTransform(rotationAngle: CGFloat.pi / 4) : CGAffineTransform.identity
        }
    }


}
