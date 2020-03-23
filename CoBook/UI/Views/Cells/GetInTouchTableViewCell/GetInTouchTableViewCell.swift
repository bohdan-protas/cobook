//
//  GetInTouchTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol GetInTouchTableViewCellDelegate: class {
    func getInTouchTableViewCellDidOccuredCallAction(_ cell: GetInTouchTableViewCell)
    func getInTouchTableViewCellDidOccuredEmailAction(_ cell: GetInTouchTableViewCell)
}

class GetInTouchTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet var telephoneButton: DesignableButton!
    @IBOutlet var emailButton: DesignableButton!

    weak var delegate: GetInTouchTableViewCellDelegate?

    // MARK: Actions
    @IBAction func telephoneButtonTapped(_ sender: UIButton) {
        delegate?.getInTouchTableViewCellDidOccuredCallAction(self)
    }

    @IBAction func emailButtonTapped(_ sender: UIButton) {
        delegate?.getInTouchTableViewCellDidOccuredEmailAction(self)
    }

    
}
