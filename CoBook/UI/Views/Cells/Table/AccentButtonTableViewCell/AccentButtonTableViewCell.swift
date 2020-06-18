//
//  AccentButtonTableViewCell.swift
//  CoBook
//
//  Created by Bogdan Protas on 18.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccentButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var accentButton: LoaderDesignableButton!
    
    var buttonActionHandler: (() -> Void)?
    
    @IBAction func accentButtonTapped(_ sender: Any) {
        buttonActionHandler?()
    }

}
