//
//  BusinessCardHeaderInfoTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class BusinessCardHeaderInfoTableViewCell: UITableViewCell {

    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var avatarImageView: DesignableImageView!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
