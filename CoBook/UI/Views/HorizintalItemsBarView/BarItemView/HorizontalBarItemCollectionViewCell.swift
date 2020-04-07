//
//  HorizontalBarItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class HorizontalBarItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var selectionIndicatorView: UIView!
    @IBOutlet var nameLabel: UILabel!
    var maxWidth: CGFloat?

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    var isSizeCalculated: Bool = false
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
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

}
