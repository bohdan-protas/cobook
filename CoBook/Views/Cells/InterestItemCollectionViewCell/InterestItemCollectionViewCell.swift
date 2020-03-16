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


    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = self.isSelected ? selectedBgColor : deselectedBgColor
            titleLabel.textColor = self.isSelected ? selectedTextColor : deselectedTextColor
            actionButton.tintColor = self.isSelected ? selectedButtonColor : deselectedButtonColor

            UIView.animate(withDuration: 0.1) {
                self.actionButton.transform = self.isSelected ? CGAffineTransform(rotationAngle: CGFloat.pi / 4) : CGAffineTransform.identity
            }
        }
    }

}
