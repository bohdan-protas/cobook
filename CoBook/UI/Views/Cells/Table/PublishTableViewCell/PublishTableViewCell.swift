//
//  PublishTableViewCell.swift
//  CoBook
//
//  Created by Bogdan Protas on 24.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class PublishTableViewCell: UITableViewCell {

    @IBOutlet weak var publishTitleLabel: UILabel!
    @IBOutlet weak var publishSubtitleLabel: UILabel!
    @IBOutlet weak var publishButton: DesignableButton!
    
    var actionHandler: (() -> Void)?
    
    @IBAction func publishButtonTapped(_ sender: Any) {
        actionHandler?()
    }
    
    
}
