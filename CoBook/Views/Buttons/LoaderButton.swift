//
//  LoaderButton.swift
//  CoBook
//
//  Created by protas on 2/17/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

@IBDesignable
class LoaderButton: DesignableButton {

    // MARK: Properties
    @IBInspectable var spinnerColor: UIColor = .black {
        didSet {
            activityIndicator.backgroundColor = spinnerColor
        }
    }

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    var isLoading: Bool = false {
        didSet {
            isLoading ? startLoaderAnimating() : stopLoaderAnimating()
        }
    }

    private var lastTitle: String?

    // MARK: Lifecycle
    override func sharedInit() {
        super.sharedInit()

        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
    }


}

// MARK: - Privates
private extension LoaderButton {

    func startLoaderAnimating() {
        lastTitle = self.titleLabel?.text
        setTitle("", for: .normal)
        isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }

    func stopLoaderAnimating() {
        setTitle(lastTitle, for: .normal)
        isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }

    func centerActivityIndicatorInButton() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator, attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }


}
