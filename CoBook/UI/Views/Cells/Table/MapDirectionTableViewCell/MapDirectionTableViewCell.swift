//
//  MapDirectionTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol MapDirectionTableViewCellDelegate: class {
    func didOpenGoogleMaps(_ view: MapDirectionTableViewCell)
}

class MapDirectionTableViewCell: UITableViewCell {

    @Localized("Button.mapDirectiron.normalTitle")
    @IBOutlet var mapDirectionButton: UIButton!
    
    weak var delegate: MapDirectionTableViewCellDelegate?

    @IBAction func mapDirectionButtonTapped(_ sender: Any) {
        delegate?.didOpenGoogleMaps(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
