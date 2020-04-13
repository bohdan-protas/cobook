//
//  BaseFromNibView.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

/// Base custom view which autocreating from nib-file
class BaseFromNibView: UIView {

    // MARK: outlets
    @IBOutlet var contentView: UIView!

    // MARK: lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    func getNib() -> UINib {
        fatalError("Method should be overriden")
    }

    func setupLayout() {
    }


}

// MARK: - Private section
fileprivate extension BaseFromNibView {

    func nibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true

        addSubview(contentView)

        setupLayout()
    }

    func loadViewFromNib() -> UIView {
        let nibView = self.getNib().instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }


}
